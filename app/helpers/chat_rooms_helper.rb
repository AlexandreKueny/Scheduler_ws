module ChatRoomsHelper

  def chat_room_header(text)
    content_for(:header) do
      "<div class='page-header'>
           <h1 class='edit'>#{text}</h1>
        </div>".html_safe
    end
  end

end
