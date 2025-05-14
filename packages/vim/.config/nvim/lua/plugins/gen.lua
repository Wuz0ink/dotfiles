return {
	{
		"David-Kunz/gen.nvim",
		config = function()
			require("gen").setup({
				model = "Axis Codestral",
				display_mode = "float",
				show_prompt = true,
				show_model = true,
				api_key = os.getenv("MISTRAL_API_KEY"),
				model_api = function(lines, prompt, callback)
					local curl = require("plenary.curl")

					local system_message = [[
You are a coding assistant with the following roles: autocomplete, chat, edit, apply.
You have access to the following context providers: code, docs, diff, terminal, problems, folder, codebase, and a repo-map (includeSignatures: false).
Respond concisely and with focus on useful code suggestions or explanations.
		]]

					-- local body = vim.fn.json_encode({
					-- 	model = "codestral-2501",
					-- 	messages = {
					-- 		{ role = "system", content = system_message},
					-- 		{ role = "user", content = prompt .. "\n\n" .. table.concat(lines, "\n") },
					-- 	}
					-- })
					
					-- local body = vim.fn.json_encode({
					-- 	model = "codestral-2501",
					-- 	prompt = prompt .. "\n\n" .. table.concat(lines, "\n"),
					-- 	temperature = 0.2,
					-- 	max_tokens = 1024,
					-- })
					local body = vim.fn.json_encode({
						model = "codestral-2501",
						prompt = "Improve this function: " .. prompt,
						temperature = 0.2,
						max_tokens = 512,
					})

					curl.post("https://gw.ext.csi-api.axis.com/ext/ai-mistral-code/v1", {
						headers = {
							["Authorization"] = "Bearer " .. os.getenv("MISTRAL_API_KEY"),
							["Content-Type"] = "application/json",
						},
						body = body,
						callback = function(res)
							local response = vim.fn.json_decode(res.body)
							local msg = response.choices[1].text
							callback(msg)
						end
					})
				end
			})
		end,
		debug = false,
		dependencies = { "nvim-lua/plenary.nvim" }
	}
}
