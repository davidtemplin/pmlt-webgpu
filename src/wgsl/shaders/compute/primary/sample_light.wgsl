@compute 
@workgroup_size(WORKGROUP_SIZE)
fn sample_light(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    let global_invocation_index = gid.x;

    var queue_id: u32 = NULL_QUEUE_ID;

    if global_invocation_index < atomicLoad(&queue_counts[SAMPLE_LIGHT_QUEUE_ID]) {
        let global_path_index = queues[SAMPLE_LIGHT_QUEUE_ID][global_invocation_index];
        let tr = rand_1(global_path_index, TECHNIQUE_STREAM_INDEX);
        let path_length = path_state.path_length[global_path_index];
        let technique = sample_technique(path_length, tr);
        queue_id = choose_u32(path_length == 2, CONNECT_QUEUE_ID, INTERSECT_QUEUE_ID);
        let cr = rand_4(global_path_index, LIGHT_STREAM_INDEX);
        let point = uniform_sample_sphere(cr[0], cr[1]) * sphere.radius[LIGHT_SPHERE_ID];
        let center = vec3f(sphere.center_x[LIGHT_SPHERE_ID], sphere.center_y[LIGHT_SPHERE_ID], sphere.center_z[LIGHT_SPHERE_ID]);
        let normal = point - center;
        let direction = cosine_sample_hemisphere(normal, cr[2], cr[3]);
        path_state.ray_origin_x[global_path_index] = point.x;
        path_state.ray_origin_y[global_path_index] = point.y;
        path_state.ray_origin_z[global_path_index] = point.z;
        path_state.ray_direction_x[global_path_index] = direction.x;
        path_state.ray_direction_y[global_path_index] = direction.y;
        path_state.ray_direction_z[global_path_index] = direction.z;
    }
    
    enqueue(global_invocation_index, lid, queue_id);
}
