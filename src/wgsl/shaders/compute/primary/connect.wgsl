@compute
@workgroup_size(WORKGROUP_SIZE)
fn connect(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid) {
    let global_invocation_index = id.x;
    let queue_id: u32 = NULL_QUEUE_ID;
    if global_invocation_index < atomicLoad(&queue_counts[CONNECT_QUEUE_ID]) {
        let global_path_index = queues[CONNECT_QUEUE_ID][global_invocation_index];
        let source_point = vec3f(path_state.final_camera_point_x[global_path_index], path_state.final_camera_point_y[global_path_index], path_state.final_camera_point_z[global_path_index]);
        let destination_point = vec3f(path_state.previous_point_x[global_path_index], path_state.previous_point_y[global_path_index], path_state.previous_point_z[global_path_index]);
        let direction = normalize(destination_point - source_point);
        let ray = Ray(source_point, direction);
        let intersection = intersect(ray);
        let pixel_coordinates = get_pixel_coordinates(ray);
        let valid = (pixel_coordinates.valid || path_length != 2) && intersection.valid && approx_eq_vec3f(intersection.point, destination_point);
        queue_id = choose_u32(valid, CONTRIBUTE_QUEUE_ID, queue_id);
    }
    enqueue(global_invocation_id, lid, queue_id);
}