@compute
@workgroup_size(WORKGROUP_SIZE)
fn intersect_main(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    let global_invocation_index: u32 = id.x;
    var queue_id: u32 = NULL_QUEUE_ID;

    if global_invocation_index < atomicLoad(&queue_counts[INTERSECT_QUEUE_ID]) {
        let global_path_index = queues[INTERSECT_QUEUE_ID][global_invocation_index];
        let ray_origin = vec3f(path_state.ray_origin_x[global_path_index], path_state.ray_origin_y[global_path_index], path_state.ray_origin_z[global_path_index]);
        let ray_direction = vec3f(path_state.ray_direction_x[global_path_index], path_state.ray_direction_y[global_path_index], path_state.ray_direction_z[global_path_index]);
        let ray = Ray(ray_origin, ray_direction);
        let intersection = intersect(ray);
        let path_length = path_state.path_length[global_path_index];
        let vertex_index = path_state.vertex_index[global_path_index];
        let light_technique = path_state.light_technique[global_path_index];
        let camera_technique = path_state.camera_technique[global_path_index];
        queue_id = choose_u32(vertex_index + 1 < camera_technique || vertex_index + 1 < light_technique, SAMPLE_MATERIAL_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == path_length - 1, CONNECT_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == camera_technique - 1 && light_technique == 0, CONTRIBUTE_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == camera_technique - 1, SAMPLE_LIGHT_QUEUE_ID, queue_id);
        queue_id = choose_u32(intersection.valid, queue_id, NULL_QUEUE_ID);
    }

    enqueue(global_invocation_index, lid, queue_id);
}