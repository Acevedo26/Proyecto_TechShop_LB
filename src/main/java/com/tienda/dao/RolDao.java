package com.tienda.dao;

import com.tienda.domain.Rol;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface RolDao extends JpaRepository<Rol, Long> {
    
    // Métodos adicionales para CRUD
    List<Rol> findByIdUsuario(Long idUsuario);
    List<Rol> findByNombre(String nombre);
    List<Rol> findByNombreContainingIgnoreCase(String nombre);
}