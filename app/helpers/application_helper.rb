module ApplicationHelper

  def header(text)
    content_for(:header) do
      "<div class='page-header'>
           <h1>#{text}</h1>
        </div>".html_safe
    end
  end
end
