async function main() {
    // Initialize config
    const config = new Config();

    // Request a device
    const adapter = await navigator.gpu?.requestAdapter({
        powerPreference: 'high-performance',
    });

    const device = await adapter?.requestDevice({
        requiredFeatures: ['timestamp-query'],
        requiredLimits: {
            maxStorageBufferBindingSize: config.memory.limit,
            maxBufferSize: config.memory.limit,
        },
    });

    if (!device) {
        alert('Your web browser does not support WebGPU');
        return;
    }

    device.addEventListener('uncapturederror', event => console.log(event.error.message));

    // Create the scene
    const scene = new Scene();

    // Initialize the GPU memory
    const data = new Data({ config, scene });
    data.initialize({ device });

    // Prepare an executor
    const executor = new Executor({ config, data });
    executor.initialize({ device });

    // Execute
    executor.execute({ device });
};

main();