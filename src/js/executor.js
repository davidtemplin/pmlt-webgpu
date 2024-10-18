class Executor {
    #config;
    #data;

    #kernels = {
        primary: {},
        auxiliary: {},
    };

    #running = true;
    #startTimestamp;
    #iterationsPerRender = 10;
    #canvasRenderingFrequency = 1;

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

        this.#kernels.primary.sampleMaterial = new SampleMaterialKernel({
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

        this.#kernels.primary.render = new RenderKernel({
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

        this.#kernels.auxiliary.buildCdf = new BuildCdfKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.startChain = new StartChainKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.buildPdf = new BuildPdfKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.distribute = new DistributeKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.updateChain = new UpdateChainKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.restart = new RestartKernel({
            config: this.#config,
            data: this.#data,
        });

        this.#kernels.auxiliary.enableImage = new EnableImageKernel({
            config: this.#config,
            data: this.#data,
        });
    }

    initialize(params) {
        this.#kernels.primary.initialize.initialize({ device: params.device });
        this.#kernels.primary.sampleCamera.initialize({ device: params.device });
        this.#kernels.primary.sampleLight.initialize({ device: params.device });
        this.#kernels.primary.intersect.initialize({ device: params.device });
        this.#kernels.primary.sampleMaterial.initialize({ device: params.device });
        this.#kernels.primary.connect.initialize({ device: params.device });
        this.#kernels.primary.postConnectNull.initialize({ device: params.device });
        this.#kernels.primary.postConnectCameraDirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectCameraIndirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectLightDirect.initialize({ device: params.device });
        this.#kernels.primary.postConnectLightIndirect.initialize({ device: params.device });
        this.#kernels.primary.contribute.initialize({ device: params.device });
        this.#kernels.primary.render.initialize({ device: params.device, presentationFormat: params.presentationFormat });

        this.#kernels.auxiliary.clearQueue.initialize({ device: params.device });
        this.#kernels.auxiliary.dispatch.initialize({ device: params.device });
        this.#kernels.auxiliary.buildCdf.initialize({ device: params.device });
        this.#kernels.auxiliary.startChain.initialize({ device: params.device });
        this.#kernels.auxiliary.buildPdf.initialize({ device: params.device });
        this.#kernels.auxiliary.distribute.initialize({ device: params.device });
        this.#kernels.auxiliary.updateChain.initialize({ device: params.device });
        this.#kernels.auxiliary.restart.initialize({ device: params.device });
        this.#kernels.auxiliary.enableImage.initialize({ device: params.device });
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

        for (let pathLength = this.#config.path.length.min; pathLength <= this.#config.path.length.max; pathLength++) {
            const chainId = pathLength - this.#config.path.length.min;

            this.#kernels.primary.initialize.encode({ pathLength, pass, device: params.device });
            this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

            for (let iteration = 1; iteration <= pathLength - 1; iteration++) {
                this.#kernels.primary.sampleCamera.encode({ pass, device: params.device });

                this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.camera, pass, device: params.device });
                this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

                this.#kernels.primary.sampleLight.encode({ pass, device: params.device });

                this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.light, pass, device: params.device });
                this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

                this.#kernels.primary.intersect.encode({ pass, device: params.device });

                this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.intersect, pass, device: params.device });
                this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

                this.#kernels.primary.sampleMaterial.encode({ pass, device: params.device });

                this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.material, pass, device: params.device });
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
            }

            this.#kernels.auxiliary.buildCdf.encode({ chainId, pass, device: params.device });

            const random = Math.random();

            this.#kernels.auxiliary.startChain.encode({ chainId, random, pass, device: params.device });
        }

        this.#kernels.auxiliary.buildPdf.encode({ pass, device: params.device });

        this.#kernels.auxiliary.distribute.encode({ pass, device: params.device });

        this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

        this.#kernels.auxiliary.enableImage.encode({ pass, device: params.device });

        pass.end();

        let commandBuffer = encoder.finish();
        params.device.queue.submit([commandBuffer]);

        requestAnimationFrame((timestamp) => this.render({...params, querySet, iteration: 1, timestamp }));
    }

    render(params) {
        if (!this.#startTimestamp) {
            this.#startTimestamp = params.timestamp;
        }
        const iterationsPerSecond = (params.iteration * this.#iterationsPerRender) * 1000.0 / (params.timestamp - this.#startTimestamp);
        console.log(`iterations per second = ${iterationsPerSecond}`);

        let encoder = params.device.createCommandEncoder({
            label: 'command encoder',
        });

        let pass = encoder.beginComputePass({
            label: 'phase 2 compute pass',
            timestampWrites: {
                querySet: params.querySet,
                beginningOfPassWriteIndex: 0,
                endOfPassWriteIndex: 1,
            },
        });

        for (let innerIteration = 1; innerIteration <= this.#iterationsPerRender; innerIteration++) {
            this.#kernels.primary.sampleCamera.encode({ pass, device: params.device });

            this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.camera, pass, device: params.device });
            this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

            this.#kernels.primary.sampleLight.encode({ pass, device: params.device });

            this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.light, pass, device: params.device });
            this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

            this.#kernels.primary.intersect.encode({ pass, device: params.device });

            this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.intersect, pass, device: params.device });
            this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });

            this.#kernels.primary.sampleMaterial.encode({ pass, device: params.device });

            this.#kernels.auxiliary.clearQueue.encode({ queueId: this.#config.queue.index.sample.material, pass, device: params.device });
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

            for (let pathLength = this.#config.path.length.min; pathLength <= this.#config.path.length.max; pathLength++) {
                const chainId = pathLength - this.#config.path.length.min;
                const totalIterations = params.iteration * this.#iterationsPerRender + innerIteration;
                if (totalIterations % (pathLength - 1) == 0) {
                    this.#kernels.auxiliary.buildCdf.encode({ chainId, pass, device: params.device }); // TODO: also include path count?
                    const random = Math.random();
                    this.#kernels.auxiliary.updateChain.encode({ chainId, random, pass, device: params.device });
                    this.#kernels.auxiliary.restart.encode({ chainId, pass, device: params.device });
                    this.#kernels.auxiliary.dispatch.encode({ pass, device: params.device });
                }
            }
        }

        pass.end();

        if (params.iteration % this.#canvasRenderingFrequency == 0) {
            pass = encoder.beginRenderPass({
                label: 'canvas render pass',
                colorAttachments: [
                    {
                        view: params.context.getCurrentTexture().createView(),
                        clearValue: [0, 0, 0, 1],
                        loadOp: 'clear',
                        storeOp: 'store',
                    },
                ],
            });

            this.#kernels.primary.render.encode({ pass, device: params.device });

            pass.end();
        }

        const commandBuffer = encoder.finish();
        params.device.queue.submit([commandBuffer]);

        if (this.#running) {
            requestAnimationFrame((timestamp) => this.render({...params, iteration: params.iteration + 1, timestamp }));
        }
    }

    stop() {
        this.#running = false;
    }
}