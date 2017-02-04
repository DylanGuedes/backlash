defmodule Backlash.StringHelperTest do
  use Backlash.ConnCase

  alias Backlash.StringHelper

  @long_word String.duplicate("a", 120)

  test "truncate with no longer string" do
    assert StringHelper.truncate(@long_word, 10)=="aaaaaaaaaa..."
  end

  test "should do nothing with not longer string" do
    assert StringHelper.truncate(@long_word, 120)==String.duplicate("a", 120)
  end

  test "should do nothing with empty string" do
    assert StringHelper.truncate("", 120)==""
  end
end
