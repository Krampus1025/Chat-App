/// scr_handle_buffer(buffer)

// Get the buffer and size
var buffer = argument[0];

// Get the message id
var message_id = buffer_read(buffer, buffer_u8);

switch (message_id) {
    case MESSAGE:
        // Get the name of the user who sent the string
        var name = buffer_read(buffer, buffer_string);
        
        // Read the string
        var str = buffer_read(buffer, buffer_string);
        
        // Format the string
        var str_fmt = name + ": " + str;
        
        // Add the string to the chatbox queue
        ds_list_add(obj_chatbox.text_lines, str_fmt);
        break;
    
    case JOIN:
        // Get the name of the user who joined
        var name = buffer_read(buffer, buffer_string);
        
        // Format the string
        var str_fmt = name + " has joined!";
        
        // Add the string to the chatbox queue
        ds_list_add(obj_chatbox.text_lines, str_fmt);
        break;
        
    case LEAVE:
        // Get the name of the user who left
        var name = buffer_read(buffer, buffer_string);
        
        // Format the string
        var str_fmt = name + " has left!";
        
        // Add the string to the chatbox queue
        ds_list_add(obj_chatbox.text_lines, str_fmt);
        break;
}
