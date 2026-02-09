---@type LazySpec
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Alpha",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    -- Custom header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "                                                     ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", "<Cmd>Telescope find_files<CR>"),
      dashboard.button("n", "  New File", "<Cmd>ene<CR>"),
      dashboard.button("r", "  Recent Files", "<Cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "  Find Word", "<Cmd>Telescope live_grep<CR>"),
      dashboard.button("s", "󰋊  Sessions", "<Cmd>SessionManager load_session<CR>"),
      dashboard.button("p", "  Git Status", "<Cmd>Telescope git_status<CR>"),
      dashboard.button("c", "  Config", "<Cmd>e $MYVIMRC<CR>"),
      dashboard.button("l", "  Lazy", "<Cmd>Lazy<CR>"),
      dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
    }

    dashboard.section.header.opts.hl = "DashboardHeader"
    dashboard.section.buttons.opts.hl = "DashboardCenter"

    dashboard.opts.layout[1].val = 4
    return dashboard.opts
  end,
}
