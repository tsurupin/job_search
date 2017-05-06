defmodule Customer.Web.Api.V1.TechKeywordControllerTest do
  use Customer.Web.ConnCase, async: true

  alias Customer.Web.TechKeyword

  setup do
    insert(:tech_keyword, name: "rails")
    insert(:tech_keyword, name: "ruby")
    insert(:tech_keyword, name: "elixir")
    Customer.Web.TechKeyword.es_reindex
  end

  test "get tech keywords" do
    conn = get build_conn(), "api/v1/tech-keywords?word=r"

    assert conn.status == 200
    body = Poison.decode!(conn.resp_body)
    assert body == ~w(ruby rails)
  end

  test "get empty list" do
     conn = get build_conn(), "api/v1/tech-keywords?word=xyz"
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      assert body == []
  end

end