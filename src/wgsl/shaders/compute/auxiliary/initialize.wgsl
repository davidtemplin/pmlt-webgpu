@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: InitializeUniforms;

@compute
@workgroup_size(WORKGROUP_SIZE)
fn initialize(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let i = id.x;

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < PATH_COUNT {
        // Set the context
        path.step_type[i] = LARGE_STEP;
        path.index[i] = i;
        path.length[i] = uniforms.path_length;
        path.vertex_index[i] = 0;
        path.cdf[PRIMARY][i] = 0;
        path.cdf[AUXILIARY][i] = 0;
        path.prod_ri[CAMERA][i] = 1.0;
        path.prod_ri[LIGHT][i] = 1.0;
        path.sum_inv_ri[CAMERA][i] = 0.0;
        path.sum_inv_ri[LIGHT][i] = 0.0;

        // Set the queue
        queue_id = SAMPLE_CAMERA_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}