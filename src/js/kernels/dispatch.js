class DispatchKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'dispatch module',
            code: DISPATCH_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'dispatch compute pipeline',
            layout: this.#data.pipelineLayout.auxiliary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const pass = params.encoder.beginComputePass({
            label: 'dispatch compute pass',
            timestampWrites: {
                querySet: params.querySet,
                beginningOfPassWriteIndex: 0,
                endOfPassWriteIndex: 1,
            },
        });

        pass.setPipeline(this.#pipeline);
        pass.setBindGroup(this.#config.bindGroup.primary.index, this.#data.bindGroup.primary);
        pass.setBindGroup(this.#config.bindGroup.auxiliary.index, this.#data.bindGroup.auxiliary);
        pass.dispatchWorkgroups(1);
        pass.end();
    }
}