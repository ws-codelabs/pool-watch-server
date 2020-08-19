defmodule PoolWatch.Email do
  use Bamboo.Phoenix, view: PoolWatchWeb.EmailView

  @from_addr "noreply@nodeinspect.com"

  def html_email(to_addr, sub, opts \\ []) do
    new_email()
    |> from(Keyword.get(opts, :from, @from_addr))
    |> to(to_addr)
    |> subject(sub)
    |> put_html_layout({PoolWatchWeb.LayoutView, "email.html"})
    |> assign(:data, Keyword.get(opts, :data, %{}))
    |> render(Keyword.get(opts, :content, ""))
  end
end
