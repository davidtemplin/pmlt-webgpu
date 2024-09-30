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

        this.#kernels.primary.sampleLight = new SampleLightKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.intersect = new IntersectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.connect = new ConnectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.postConnectNull = new PostConnectNullKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.postConnectCameraDirect = new PostConnectCameraDirectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.postConnectCameraIndirect = new PostConnectCameraIndirectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.postConnectLightDirect = new PostConnectLightDirectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.postConnectLightIndirect = new PostConnectLightIndirectKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.primary.contribute = new ContributeKernel({
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
        this.#kernels.primary.sampleLight.initialize({ device: params.device });
        this.#kernels.primary.intersect.initialize({ device: params.device });
        this.#kernels.primary.connect.initialize({ device: params.device });
        this.#kernels.primary.postConnectNull.initialize({ device: params.device });
        this.#kernels.primary.postConnectCameraDirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectCameraIndirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectLightDirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectLightIndirect.initialize({ device: params.device });
        this.#kernels.primary.contribute.initialize({ device: params.device });

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

        this.#kernels.primary.initialize.encode({ pathLength: 2, pass, device: params.device });

        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.sampleCamera.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.camera, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.sampleLight.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.light, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.intersect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.intersect, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.connect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.connect, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.postConnectNull.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.postConnect.null, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.postConnectCameraDirect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.postConnect.camera.direct, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.postConnectCameraIndirect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.postConnect.camera.indirect, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.postConnectLightDirect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.postConnect.light.direct, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.postConnectLightIndirect.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.postConnect.light.indirect, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.primary.contribute.encode({ pass, device: params.device });

        this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.contribute, pass, device: params.device });
        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

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