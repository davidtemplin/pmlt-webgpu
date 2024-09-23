@compute
@workgroup_size(WORKGROUP_SIZE)
fn connect(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[CONNECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    let queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[CONNECT_QUEUE_ID]) {
        // Context
        let path_length = path.length[i];

        // Intersect
        let source = get_point(CAMERA, ULTIMATE, i);
        let destination = get_point(LIGHT, ULTIMATE, i);
        let direction = normalize(destination - source);
        let ray = Ray(source, direction);
        let intersection = intersect(ray);

        // Compute pixel coordinates; TODO: update pixel coordinates in path state
        let pixel_coordinates = get_pixel_coordinates(ray);
        let valid = (pixel_coordinates.valid || path_length != 2) && intersection.valid && approx_eq_vec3f(intersection.point, destination);

        // Scalar contribution
        path.scalar_contribution[i] = choose_f32(valid, path.scalar_contribution[i], 0.0);

        // Determine queue
        queue_id = choose_u32(path_length == 2, POST_CONNECT_DIRECT_QUEUE_ID, queue_id);
        queue_id = choose_u32(technique.camera > 1, POST_CONNECT_CAMERA_QUEUE_ID, queue_id);
        queue_id = choose_u32(technique.camera < 2, POST_CONNECT_LIGHT_QUEUE_ID, queue_id);
        queue_id = choose_u32(valid, queue_id, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}