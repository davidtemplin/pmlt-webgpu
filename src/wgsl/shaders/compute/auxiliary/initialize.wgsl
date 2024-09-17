@group(UNIFORMS_GROUP) @binding(UNIFORMS_BINDING) var<uniform> uniforms: InitializeUniforms;

@compute
@workgroup_size(WORKGROUP_SIZE)
fn initialize(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    let global_path_index = id.x;
    var queue_id: u32 = NULL_QUEUE_ID;    
    if global_path_index < PATH_COUNT {
        path_state.step_type[global_path_index] = LARGE_STEP;
        path_state.local_path_index[global_path_index] = global_path_index;
        path_state.path_length[global_path_index] = uniforms.path_length;
        path_state.vertex_index[global_path_index] = 0;
        path_state.scalar_contribution[global_path_index] = 1.0; // TODO fix; temporary for testing
        queue_id = SAMPLE_CAMERA_QUEUE_ID;
    }
    enqueue(global_path_index, lid, queue_id);
}