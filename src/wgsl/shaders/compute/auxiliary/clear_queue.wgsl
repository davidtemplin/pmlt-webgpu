@group(UNIFORMS_GROUP) @binding(UNIFORMS_BINDING) var<uniform> uniforms: ClearQueueUniforms;

@compute
@workgroup_size(1)
fn clear_queue() {
    atomicStore(&queue_counts[uniforms.queue_id], 0);
}