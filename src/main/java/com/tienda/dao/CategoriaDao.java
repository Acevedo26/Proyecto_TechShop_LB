package com.tienda.dao;

import com.tienda.domain.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CategoriaDao extends JpaRepository<Categoria, Long> {
    
    // Método para encontrar categorías activas
    List<Categoria> findByActivoTrue();
    
    // Método para encontrar por descripción
    List<Categoria> findByDescripcionContainingIgnoreCase(String descripcion);
}