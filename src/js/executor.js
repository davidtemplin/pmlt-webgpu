class Executor {
    #config;
    #data;

    #kernels = {};

    constructor(params) {
        this.#config = params.config;
        this.#data = params.data;

        this.#kernels.initialize = new InitializeKernel({ 
            config: this.#config,
            data: this.#data,
        });
    }

    initialize(params) {
        this.#kernels.initialize.initialize({ device: params.device });
    }

    execute(params) {
        const encoder = params.device.createCommandEncoder({
            label: 'command encoder',
        });

        const querySet = params.device.createQuerySet({
            type: 'timestamp',
            count: 2,
        });

        this.#kernels.initialize.encode({ encoder, device: params.device, querySet });

        const debug = new Debug({ label: 'queue', data: this.#data.element.queue });
        debug.encode({ encoder, device: params.device });

        const commandBuffer = encoder.finish();
        params.device.queue.submit([commandBuffer]);

        debug.log();
    }
}