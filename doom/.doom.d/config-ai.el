;;; ../.dotfiles/doom/.doom.d/config-ai.el -*- lexical-binding: t; -*-

(use-package! gptel
  :config
  (setq gptel-directives
        '((default
           . "You are a large language model living in Emacs and a helpful assistant. Respond concisely.")
          (programming
           . "You are a large language model and a careful programmer.
        Write code that is simple and direct. Use the programming language directly.
        If you need to change code outside current file, comment it with the prefix TODO:.
        Provide code and only code as output without any additional text, prompt or note.")
          (writing
           . "You are a large language model and a writing assistant. Respond concisely.")
          (chat
           . "You are a large language model and a conversation partner. Respond concisely.")))
  (gptel-make-deepseek "DeepSeek"
    :stream t
    :key (getenv "DEEPSEEK_APIKEY"))
  ;; (gptel-make-openai "SiliconFlow"
  ;;   :host "api.siliconflow.cn"
  ;;   :endpoint "/v1/chat/completions"
  ;;   :stream t
  ;;   :key (getenv "SILICONFLOW_APIKEY")
  ;;   :models '(deepseek-ai/DeepSeek-R1 deepseek-ai/DeepSeek-V3
  ;;             Pro/deepseek-ai/DeepSeek-R1 Pro/deepseek-ai/DeepSeek-V3
  ;;             ))
  ;; TODO: test it
  ;; (gptel-make-openai "OhMyGPT"
  ;;   :host "cn2us02.opapi.win"
  ;;   :endpoint "/v1/chat/completions"
  ;;   :stream t
  ;;   :key (getenv "OPENAI_APIKEY"))
  (gptel-make-openai "tubi-open-ai"
    :stream t
    :key (getenv "TUBI_OPENAI_APIKEY")
    :models '(gpt-5.1 gpt-5 gpt-5-mini gpt-5-nano gpt-4o o3 o3-mini))
  ;; (setq gptel-backend (gptel-get-backend "tubi-open-ai"))
  (map! :leader (:prefix ("e" . "GPTel - AI")
                 :n "a" #'gptel :desc "GPTel buffer"
                 :n "e" #'gptel-send :desc "GPTel Send"
                 :n "s" #'gptel-menu :desc "GPTel Menu"
                 :n "b" #'gptel-abort :desc "GPTel Abort" )))
