@compute 
@workgroup_size(WORKGROUP_SIZE)
fn sample_light_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine global path index (i)
    let global_invocation_index = gid.x;
    let i = queues[SAMPLE_LIGHT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue_counts[SAMPLE_LIGHT_QUEUE_ID]) {
        // Sample        
        let sample = sample_light(rand_4(global_path_index, LIGHT_STREAM_INDEX));

        // Set initial ray
        set_ray_origin(sample.point);
        set_ray_direction(sample.direction);

        // MIS
        path.pdf_fwd[LIGHT][ULTIMATE][i] = sample.positional_pdf;

        // PDF
        path.directional_pdf[LIGHT][i] = sample.directional_pdf;

        // Beta
        let radiance = get_sphere_color(LIGHT_SPHERE_ID);
        let beta = radiance / sample.positional_pdf;
        update_beta(i, beta);

        // Geometry
        set_point(LIGHT, ULTIMATE, i, sample.point);
        set_normal(LIGHT, ULTIMATE, i, sample.normal);

        // Determine queue
        queue_id = choose_u32(path.length[i] == 2, CONNECT_QUEUE_ID, INTERSECT_QUEUE_ID);
    }
    
    // Enqueue
    enqueue(global_invocation_index, lid, queue_id);
}
