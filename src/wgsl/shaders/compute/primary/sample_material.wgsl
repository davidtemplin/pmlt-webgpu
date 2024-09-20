@compute
@workgroup_size(WORKGROUP_SIZE)
fn sample_material(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid) {
    let global_invocation_index = id.x;
    let queue_id: u32 = NULL_QUEUE_ID;
    if global_invocation_index < atomicLoad(&queue_counts[SAMPLE_MATERIAL_QUEUE_ID]) {
        let global_path_index = sample_material_queue[global_invocation_index];
        let normal = vec3f(path_state.previous_normal_x[global_path_index], path_state.previous_normal_y[global_path_index], path_state.previous_normal_z[global_path_index]);
        let vertex_index = path_state.vertex_index[global_path_index];
        let stream_index = choose_u32(vertex_index < camera_technique, CAMERA_STREAM_INDEX, LIGHT_STREAM_INDEX);
        let r = rand_2(global_path_index, stream_index);
        let sample = sample_matte_material(normal, r);
        queue_id = choose_u32(sample.valid, INTERSECT_QUEUE_ID, queue_id);
    }
    enqueue(global_invocation_id, lid, queue_id);
}