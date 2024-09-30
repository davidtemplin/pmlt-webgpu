class SampleMaterialKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'sample material module',
            code: SAMPLE_MATERIAL_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'sample material compute pipeline',
            layout: this.#data.pipelineLayout.primary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        params.pass.setPipeline(this.#pipeline);
        params.pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        params.pass.dispatchWorkgroupsIndirect(this.#data.element.dispatchIndirectParameters.buffer, 16 * this.#config.queue.index.sample.material);
    }
}