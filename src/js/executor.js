class Executor {
    #config;
    #data;

    #kernels = {
        primary: {},
        auxiliary: {},
    };

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;

        this.#kernels.primary.initialize = new InitializeKernel({ 
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.sampleCamera = new SampleCameraKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.clearQueue = new ClearQueueKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.dispatch = new DispatchKernel({
            config: this.#config,
            data: this.#data,
        });
    }

    initialize(params) {
        this.#kernels.primary.initialize.initialize({ device: params.device });
        this.#kernels.primary.sampleCamera.initialize({ device: params.device });

        this.#kernels.auxiliary.clearQueue.initialize({ device: params.device });
        this.#kernels.auxiliary.dispatch.initialize({ device: params.device });
    }

    execute(params) {
        const encoder = params.device.createCommandEncoder({
            label: 'command encoder',
        });

        const querySet = params.device.createQuerySet({
            type: 'timestamp',
            count: 2,
        });

        const pass = encoder.beginComputePass({
            label: 'phase 1 compute pass',
            timestampWrites: {
                querySet,
                beginningOfPassWriteIndex: 0,
                endOfPassWriteIndex: 1,
            },
        });

        this.#kernels.primary.initialize.encode({ pathLength: 2, pass, device: params.device, querySet });

        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device, querySet });

        this.#kernels.primary.sampleCamera.encode({ pass, device: params.device, querySet });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.camera, pass, device: params.device, querySet });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device, querySet });

        pass.end();

        const timestamp = new Timestamp();
        timestamp.prepare({ querySet, device: params.device, encoder });

        const debug = new Debug({ label: 'queue', data: this.#data.element.queue });
        debug.encode({ encoder, device: params.device });

        const commandBuffer = encoder.finish();
        params.device.queue.submit([commandBuffer]);

        timestamp.log();
        debug.log();
    }
}