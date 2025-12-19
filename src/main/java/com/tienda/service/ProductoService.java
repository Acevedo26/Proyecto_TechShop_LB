package com.tienda.service;

import com.tienda.domain.Producto;
import java.util.List;

public interface ProductoService {

    // Se obtiene un listado de categorías en un List
    public List<Producto> getProductos(boolean activos);

    // Se obtiene un Producto, a partir del id de un producto
    public Producto getProducto(Producto producto);

    // Se inserta un nuevo producto si el id del producto esta vacío
    // Se actualiza un producto si el id del producto NO esta vacío
    public void save(Producto producto);

    // Se elimina el producto que tiene el id pasado por parámetro
    public void delete(Producto producto);
    
    // Se define el metodo para llamar a la consulta ampliada
    public List<Producto> findByPrecioBetweenOrderByDescripcion(double precioInf, double precioSup);
    
    // Se define el metodo para llamar a la consulta ampliada JPQL
    public List<Producto> metodoJPQL(double precioInf, double precioSup);
    
    // Se define el metodo para llamar a la consulta ampliada SQL
    public List<Producto> metodoSQL(double precioInf, double precioSup);


}
