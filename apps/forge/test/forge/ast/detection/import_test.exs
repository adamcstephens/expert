defmodule Forge.Ast.Detection.ImportTest do
  alias Forge.Ast.Detection

  use Forge.Test.DetectionCase,
    for: Detection.Import,
    assertions: [[:import, :*]]

  test "works on multi line" do
    assert_detected ~q(
      import« Some.Module, only: »[
        foo: 3,
        bar: 6
      ]
    )
  end
end
