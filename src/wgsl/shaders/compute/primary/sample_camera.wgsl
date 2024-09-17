@compute 
@workgroup_size(WORKGROUP_SIZE)
fn sample_camera(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    let global_invocation_index = gid.x;

    var queue_id: u32 = NULL_QUEUE_ID;

    if global_invocation_index < atomicLoad(&queue_counts[SAMPLE_CAMERA_QUEUE_ID]) {
        let global_path_index = queues[SAMPLE_CAMERA_QUEUE_ID][global_invocation_index];
        let tr = rand_1(global_path_index, TECHNIQUE_STREAM_INDEX);
        let path_length = path_state.path_length[global_path_index];
        let technique = sample_technique(path_length, tr);
        queue_id = choose_u32(path_length == 2, SAMPLE_LIGHT_QUEUE_ID, INTERSECT_QUEUE_ID);
        let cr = rand_2(global_path_index, CAMERA_STREAM_INDEX);
        let u = camera.u * (cr[0] - f32(PIXEL_WIDTH) / 2.0);
        let v = -camera.v * (cr[1] - f32(PIXEL_HEIGHT) / 2.0);
        let w = camera.w * camera.distance;
        let direction = normalize(u + v + w);
        path_state.ray_origin_x[global_path_index] = camera.origin.x;
        path_state.ray_origin_y[global_path_index] = camera.origin.y;
        path_state.ray_origin_z[global_path_index] = camera.origin.z;
        path_state.ray_direction_x[global_path_index] = direction.x;
        path_state.ray_direction_y[global_path_index] = direction.y;
        path_state.ray_direction_z[global_path_index] = direction.z;
    }
    
    enqueue(global_invocation_index, lid, queue_id);
}
