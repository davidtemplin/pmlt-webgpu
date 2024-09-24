@group(UNIFORMS_GROUP) @binding(UNIFORMS_BINDING) var<uniform> uniforms: ClearQueueUniforms;

@compute
@workgroup_size(1)
fn clear_queue() {
    atomicStore(&queue.count[uniforms.queue_id], 0);
}