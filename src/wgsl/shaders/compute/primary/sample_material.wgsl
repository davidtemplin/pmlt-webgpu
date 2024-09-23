@compute
@workgroup_size(WORKGROUP_SIZE)
fn sample_material(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[SAMPLE_MATERIAL_QUEUE_ID][global_invocation_index];

    // Default to no queue
    let queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[SAMPLE_MATERIAL_QUEUE_ID]) {
        // Context
        let vertex_index = path.vertex_index[i];
        let technique = get_technique(i);
        let stream_index = choose_u32(vertex_index < technique.camera, CAMERA_STREAM_INDEX, LIGHT_STREAM_INDEX);
        let path_type = choose_u32(vertex_index < technique.camera, CAMERA, LIGHT);

        // Sample
        let normal = get_normal(path_type, ULTIMATE, i);
        let sample = sample_matte_material(normal, rand_2(i, stream_index));

        // MIS
        let ri = sample.pdf_rev / path.pdf_fwd[path_type][ULTIMATE][i];
        path.prod_ri[path_type][i] *= ri;
        path.sum_inv_ri[path_type][i] += 1.0 / ri;

        // PDF
        path.directional_pdf[path_type][i] = sample.pdf_fwd;

        // Beta
        let beta = sample.throughput / sample.pdf_fwd;
        update_beta(i, beta);

        // Determine queue
        queue_id = choose_u32(sample.valid, INTERSECT_QUEUE_ID, queue_id);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}