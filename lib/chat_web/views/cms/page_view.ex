defmodule ChatWeb.CMS.PageView do
  use ChatWeb, :view

  alias Chat.CMS

  def author_name(%CMS.Page{author: author}) do
    author.user.name
  end
end
