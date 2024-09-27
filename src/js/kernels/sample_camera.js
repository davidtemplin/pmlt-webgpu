class SampleCameraKernel {
    #config;
    #data;
    #pipeline;

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;
    }

    initialize(params) {
        const module = params.device.createShaderModule({
            label: 'sample camera module',
            code: SAMPLE_CAMERA_CODE,
        });

        this.#pipeline = params.device.createComputePipeline({
            label: 'sample camera compute pipeline',
            layout: this.#data.pipelineLayout.primary,
            compute: {
                module,
            }
        });
    }

    encode(params) {
        const pass = params.encoder.beginComputePass({
            label: 'sample_camera compute pass',
            timestampWrites: {
                querySet: params.querySet,
                beginningOfPassWriteIndex: 0,
                endOfPassWriteIndex: 1,
            },
        });

        pass.setPipeline(this.#pipeline);
        pass.setBindGroup(0, this.#data.bindGroup.primary);
        pass.dispatchWorkgroupsIndirect(this.#data.element.dispatchIndirectParameters.buffer, 16 * this.#config.queue.index.sample.camera);
        pass.end();
    }
}