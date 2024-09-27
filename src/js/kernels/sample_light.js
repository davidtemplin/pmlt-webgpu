class SampleLightKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'sample light module',
            code: SAMPLE_LIGHT_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'sample light compute pipeline',
            layout: this.#data.pipelineLayout.primary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const pass = params.encoder.beginComputePass({
            label: 'sample_light compute pass',
            timestampWrites: {
                querySet: params.querySet,
                beginningOfPassWriteIndex: 0,
                endOfPassWriteIndex: 1,
            },
        });

        pass.setPipeline(this.#pipeline);
        pass.setBindGroup(0, this.#data.bindGroup.primary);
        pass.dispatchWorkgroupsIndirect(this.#data.element.dispatchIndirectParameters.buffer, 16 * this.#config.queue.index.sample.light);
        pass.end();
    }
}