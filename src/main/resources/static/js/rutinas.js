/* La siguiente función se utiliza para visualizar la imagen seleccionada en la
 * página html donde se desea "cargar" utilizando un llamado "ajax"*/
function mostrarImagen(input) {
    if (input.files && input.files[0]) {
        var lector = new FileReader();
        lector.onload = function (e) {
            $('#blah').attr('src', e.target.result)
                    .height(200);
        };
        lector.readAsDataURL(input.files[0]);
    }
}

/* La siguiente función se utiliza para activar la cantidad de elementos seleccionados
 * En el carrito de compras utilizando un llamado "ajax" */
function addCard(formulario) {
    var valor = formulario.elements[0].value;
    var url = '/carrito/agregar';
    url = url + '/' + valor;
    $("#resultsBlock").load(url);
    }