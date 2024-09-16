local M = {}

M.setup = function()
  local llm = require('llm')
  llm.setup({
    backend = "ollama",             -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
    model = "codegemma:7b",         -- the model ID, behavior depends on backend
    url = "http://localhost:11434", -- the http url of the backend
    request_body = {
      -- Modelfile options for the model you use
      options = {
        temperature = 0.2,
        top_p = 0.95,
        num_predict = 100,
      }
    },
    context_window = 1024,
    lsp = {
      bin_path = nil,
      host = nil,
      port = nil,
      cmd_env = { LLM_LOG_LEVEL = "DEBUG" },
    },
    fim = {
      enabled = false,
    },
  })
end

return M
