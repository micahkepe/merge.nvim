local M = {}

-- Create floating windows for diff view
local function create_diff_windows(current_changes, incoming_changes)
    -- Calculate dimensions
    local width = math.floor(vim.o.columns * 0.4)
    local height = math.max(#current_changes, #incoming_changes)
    local col = math.floor((vim.o.columns - width * 2) / 3)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create buffers
    local current_buf = vim.api.nvim_create_buf(false, true)
    local incoming_buf = vim.api.nvim_create_buf(false, true)

    -- Set buffer contents
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, current_changes)
    vim.api.nvim_buf_set_lines(incoming_buf, 0, -1, false, incoming_changes)

    -- Window configurations
    local win_opts = {
        relative = 'editor',
        style = 'minimal',
        border = 'rounded',
        width = width,
        height = height,
    }

    -- Create windows
    local current_win = vim.api.nvim_open_win(current_buf, false, vim.tbl_extend('force', win_opts, {
        row = row,
        col = col,
        title = 'Current Changes',
        title_pos = 'center',
    }))

    local incoming_win = vim.api.nvim_open_win(incoming_buf, false, vim.tbl_extend('force', win_opts, {
        row = row,
        col = col * 2 + width,
        title = 'Incoming Changes',
        title_pos = 'center',
    }))

    -- Set buffer options
    for _, buf in ipairs({current_buf, incoming_buf}) do
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    end

    return {
        buffers = {current = current_buf, incoming = incoming_buf},
        windows = {current = current_win, incoming = incoming_win}
    }
end

-- Find conflict markers and extract content
local function find_current_conflict()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    
    -- Find conflict markers around cursor
    local start_marker, separator, end_marker = nil, nil, nil
    
    -- Search backwards for start
    for i = cursor_line, 1, -1 do
        if lines[i]:match("^<<<<<<< ") then
            start_marker = i
            break
        end
    end
    
    -- Search forwards for end
    for i = cursor_line, #lines do
        if lines[i]:match("^>>>>>>> ") then
            end_marker = i
            break
        end
    end
    
    -- Find separator
    if start_marker and end_marker then
        for i = start_marker, end_marker do
            if lines[i]:match("^=======") then
                separator = i
                break
            end
        end
    end
    
    if start_marker and separator and end_marker then
        local current_changes = vim.list_slice(lines, start_marker + 1, separator - 1)
        local incoming_changes = vim.list_slice(lines, separator + 1, end_marker - 1)
        return {
            current = current_changes,
            incoming = incoming_changes,
            markers = {
                start = start_marker,
                separator = separator,
                end = end_marker
            }
        }
    end
    
    return nil
end

-- Plugin configuration
M.setup = function(opts)
    opts = opts or {}
    
    -- Create user commands
    vim.api.nvim_create_user_command('MergeEditor', function()
        local conflict = find_current_conflict()
        if not conflict then
            vim.notify("No merge conflict found at cursor position", vim.log.levels.ERROR)
            return
        end
        
        local windows = create_diff_windows(conflict.current, conflict.incoming)
        
        -- Set up keymaps for the diff views
        local function close_windows()
            vim.api.nvim_win_close(windows.windows.current, true)
            vim.api.nvim_win_close(windows.windows.incoming, true)
        end
        
        -- Add keymaps for accepting changes
        for _, buf in pairs(windows.buffers) do
            vim.keymap.set('n', 'q', close_windows, { buffer = buf })
            vim.keymap.set('n', '<leader>mc', function()
                vim.api.nvim_buf_set_lines(0, conflict.markers.start - 1, conflict.markers.end, false, conflict.current)
                close_windows()
            end, { buffer = buf })
            
            vim.keymap.set('n', '<leader>mi', function()
                vim.api.nvim_buf_set_lines(0, conflict.markers.start - 1, conflict.markers.end, false, conflict.incoming)
                close_windows()
            end, { buffer = buf })
            
            vim.keymap.set('n', '<leader>mb', function()
                local combined = vim.list_extend(vim.list_slice(conflict.current), conflict.incoming)
                vim.api.nvim_buf_set_lines(0, conflict.markers.start - 1, conflict.markers.end, false, combined)
                close_windows()
            end, { buffer = buf })
        end
    end, {})
end

return M