/// scr_handle_buffer(buffer)

// Get the id
var message_id = buffer_read(buffer, buffer_u8);

switch (message_id) {
    case MESSAGE:
        // Find the client who sent this message
        var username = buffer_read(buffer, buffer_string);
        var index = ds_list_find_index(obj_clientlist.clients, username);
        
        // Get the string
        var str = buffer_read(buffer, buffer_string);
        
        // Create the message buffer
        var msg = buffer_create(1024, buffer_fixed, 1);
        buffer_write(msg, buffer_u8, message_id);
        buffer_write(msg, buffer_string, username);
        buffer_write(msg, buffer_string, str);
        
        // Send the message to everyone
        for (var i = 0; i < ds_list_size(obj_server.clients); i++) {
            // Skip if this index is the sender
            if (i == index) {
                continue;
            } 
            
            var client = ds_list_find_value(obj_server.clients, i);
            network_send_packet(client, msg, buffer_tell(msg));
        }
        
        // Delete the message buffer
        buffer_delete(msg);
        break;
        
    case JOIN:
        // Find the client who joined
        var username = buffer_read(buffer, buffer_string);
        
        // Add the name to the client list
        ds_list_add(obj_clientlist.clients, username);
        
        // Get the index that the client is at
        var index = ds_list_find_index(obj_clientlist.clients, username);
        
        // Create the joiner buffer
        var joiner = buffer_create(1024, buffer_fixed, 1);
        buffer_write(joiner, buffer_u8, message_id);
        buffer_write(joiner, buffer_string, username);
        
        // Send the message to everyone
        for (var i = 0; i < ds_list_size(obj_server.clients); i++) {
            // Skip if this index is the sender
            if (i == index) {
                continue;
            } 
            
            var client = ds_list_find_value(obj_server.clients, i);
            network_send_packet(client, joiner, buffer_tell(joiner));
        }
        
        // Delete the message buffer
        buffer_delete(joiner);
        break;
        
    case LEAVE:
        // Find the client who is leaving
        var username = buffer_read(buffer, buffer_string);
        
        // Get the index that the client is at
        var index = ds_list_find_index(obj_clientlist.clients, username);
        
        // Remove the name from the client list
        ds_list_delete(obj_clientlist.clients, index);
        
        // Create the leaver buffer
        var leaver = buffer_create(1024, buffer_fixed, 1);
        buffer_write(leaver, buffer_u8, message_id);
        buffer_write(leaver, buffer_string, username);
        
        // Send the message to everyone
        for (var i = 0; i < ds_list_size(obj_server.clients); i++) {
            // Skip if this index is the leaver
            if (i == index) {
                continue;
            } 
            
            var client = ds_list_find_value(obj_server.clients, i);
            network_send_packet(client, leaver, buffer_tell(leaver));
        }
        
        // Delete the message buffer
        buffer_delete(leaver);
        break;
}
