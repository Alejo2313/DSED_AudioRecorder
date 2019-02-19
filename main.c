#include "esp_common.h"
#include "freertos/task.h"
#include "gpio.h"
#include "fsm.h"
#define LED 2 // Led integrado
#define PERIOD_TICK 100/portTICK_RATE_MS
/******************************************************************************
 * FunctionName : user_rf_cal_sector_set
 * Description  : SDK just reversed 4 sectors, used for rf init data and paramters.
 *                We add this function to force users to set rf cal sector, since
 *                we don't know which sector is free in user's application.
 *                sector map for last several sectors : ABCCC
 *                A : rf cal
 *                B : rf init data
 *                C : sdk parameters
 * Parameters   : none
 * Returns      : rf cal sector
*******************************************************************************/
uint32 user_rf_cal_sector_set(void)
{
    flash_size_map size_map = system_get_flash_size_map();
    uint32 rf_cal_sec = 0;
    switch (size_map) {
        case FLASH_SIZE_4M_MAP_256_256:
            rf_cal_sec = 128 - 5;
            break;

        case FLASH_SIZE_8M_MAP_512_512:
            rf_cal_sec = 256 - 5;
            break;

        case FLASH_SIZE_16M_MAP_512_512:
        case FLASH_SIZE_16M_MAP_1024_1024:
            rf_cal_sec = 512 - 5;
            break;

        case FLASH_SIZE_32M_MAP_512_512:
        case FLASH_SIZE_32M_MAP_1024_1024:
            rf_cal_sec = 1024 - 5;
            break;

        default:
            rf_cal_sec = 0;
            break;
    }

    return rf_cal_sec;
}

/**
 * Tabla con los posibles estados
*/
enum fsm_state{
    LED_ON,
    LED_OFF,
};

/**
 * Funcion de guarda que controla el nivel del interruptor.
 * Hay que añadirle un mecanismo antirrebotes
 * */
int button_pressed (fsm_t * this){
    return !GPIO_INPUT_GET(5);
}


/**
 * Funcion que controla el apagado del led.
 * Si usase una interrupcion tiene que poner
 * a cero el flag correspondiente 
 * */
void led_off(fsm_t * this){
    GPIO_OUTPUT_SET(LED,1);
}

/**
 * Funcion que controla el encendido del led.
 * */
void led_on(fsm_t * this){
    GPIO_OUTPUT_SET(LED,0);
}

/**
 * Tabla con las posibles transiciones de la maquina de estados
 * Siguen un esquema:
 * {EstadoInicial,funcionComprobacion,EstadoSiguiente,funcionActualizacion}
*/
static fsm_trans_t interruptor[] = {
  { LED_OFF, button_pressed, LED_ON,  led_on },
  { LED_ON,  button_pressed, LED_OFF, led_off},
  {-1, NULL, -1, NULL },
};


/**
 * Funcion a ejecutar. Inicializo la maquina de estados,
 * configuro los pines a conveniencia y controlo el tiem-
 * po de actualizacion
*/
void inter(void * ignore){
    fsm_t * fsm = fsm_new(interruptor);
    PIN_PULLUP_EN(5);

    while(1){
        fsm_fire(fsm);
        vTaskDelay(PERIOD_TICK);
    }
}

void task_blink(void* ignore)
{
    gpio16_output_conf();
    while(true) {
    	gpio16_output_set(0);
        vTaskDelay(1000/portTICK_RATE_MS);
    	gpio16_output_set(1);
        vTaskDelay(1000/portTICK_RATE_MS);
    }

    vTaskDelete(NULL);
}

/******************************************************************************
 * FunctionName : user_init
 * Description  : entry of user application, init user function here
 * Parameters   : none
 * Returns      : none
*******************************************************************************/
void user_init(void)
{
    xTaskCreate(task_blink, "startup", 2048, NULL, 1, NULL);
    vTaskStartScheduler();
}

