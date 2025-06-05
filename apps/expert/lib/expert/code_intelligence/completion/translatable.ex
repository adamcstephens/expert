defprotocol Expert.CodeIntelligence.Completion.Translatable do
  alias GenLSP.Structures.CompletionItem
  alias Forge.Ast.Env
  alias Expert.CodeIntelligence.Completion.Builder

  @type t :: any()

  @type translated :: [CompletionItem.t()] | CompletionItem.t() | :skip

  @fallback_to_any true
  @spec translate(t, Builder.t(), Env.t()) :: translated
  def translate(item, builder, env)
end

defimpl Expert.CodeIntelligence.Completion.Translatable, for: Any do
  def translate(_any, _builder, _environment) do
    :skip
  end
end
