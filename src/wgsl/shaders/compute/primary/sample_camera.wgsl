@compute 
@workgroup_size(WORKGROUP_SIZE)
fn sample_camera_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[SAMPLE_CAMERA_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[SAMPLE_CAMERA_QUEUE_ID]) {
        // Determine technique
        let path_length = path.length[i];
        let technique = sample_technique(path_length, rand_1(i, TECHNIQUE_STREAM_INDEX));
        set_technique(i, technique);

        // Sample
        let sample = sample_camera(rand_2(i, CAMERA_STREAM_INDEX));

        // Set initial ray
        set_ray_origin(i, sample.point);
        set_ray_direction(i, sample.direction);

        // Set pixel coordinates
        set_pixel(i, sample.x, sample.y);

        // MIS
        path.pdf_fwd[CAMERA][ULTIMATE][i] = sample.positional_pdf;

        // PDF
        path.directional_pdf[i] = sample.directional_pdf;

        // Beta
        let importance = camera_importance(sample.direction);
        let beta = vec3f(1.0, 1.0, 1.0) * (choose_f32(technique.camera > 1, importance, 1.0) / sample.positional_pdf);
        set_beta(i, beta);

        // Geometry
        set_point(CAMERA, ULTIMATE, i, sample.point);
        set_normal(CAMERA, ULTIMATE, i, sample.normal);

        // Determine queue
        queue_id = choose_u32(technique.camera > 1, INTERSECT_QUEUE_ID, SAMPLE_LIGHT_QUEUE_ID);

        // Log
        log_vertex(CAMERA, i);
    }
    
    // Enqueue
    enqueue(i, lid, queue_id);
}
