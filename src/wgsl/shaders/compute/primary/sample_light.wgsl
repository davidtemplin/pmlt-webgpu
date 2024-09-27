@compute 
@workgroup_size(WORKGROUP_SIZE)
fn sample_light_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[SAMPLE_LIGHT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[SAMPLE_LIGHT_QUEUE_ID]) {
        // Sample        
        let sample = sample_light(rand_4(global_path_index, LIGHT_STREAM_INDEX));

        // Set initial ray
        set_ray_origin(i, sample.point);
        set_ray_direction(i, sample.direction);

        // MIS
        path.pdf_fwd[LIGHT][ULTIMATE][i] = sample.positional_pdf;

        // PDF
        path.directional_pdf[i] = sample.directional_pdf;

        // Beta
        let radiance = get_sphere_color(LIGHT_SPHERE_ID);
        let beta = radiance / sample.positional_pdf;
        update_beta(i, beta);

        // Geometry
        set_point(LIGHT, ULTIMATE, i, sample.point);
        set_normal(LIGHT, ULTIMATE, i, sample.normal);

        // Determine queue
        queue_id = choose_u32(technique.light == 1, CONNECT_QUEUE_ID, INTERSECT_QUEUE_ID);
    }
    
    // Enqueue
    enqueue(i, lid, queue_id);
}
