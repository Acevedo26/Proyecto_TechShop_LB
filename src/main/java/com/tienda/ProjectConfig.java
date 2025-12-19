package com.tienda;

import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

@Configuration
public class ProjectConfig implements WebMvcConfigurer {

    /* Los siguientes métodos son para incorporar el tema de internacionalización en el proyecto */

 /* localeResolver se utiliza para crear una sesión de cambio de idioma*/
    @Bean
    public LocaleResolver localeResolver() {
        var slr = new SessionLocaleResolver();
        slr.setDefaultLocale(Locale.getDefault());
        slr.setLocaleAttributeName("session.current.locale");
        slr.setTimeZoneAttributeName("session.current.timezone");
        return slr;
    }

    /* localeChangeInterceptor se utiliza para crear un interceptor de cambio de idioma*/
    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        var lci = new LocaleChangeInterceptor();
        lci.setParamName("lang");
        return lci;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registro) {
        registro.addInterceptor(localeChangeInterceptor());
    }

    //Bean para poder acceder a los Messages.properties en código...
    @Bean("messageSource")
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasenames("messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }

//    /* finalizan los métodos para incorporar el tema de internacionalización en el proyecto */
//    //los siguientes metodos son para realizar la parte de autenticacion y autorizacion
    @Override
    public void addViewControllers(ViewControllerRegistry registro) {
        registro
                .addViewController("/").setViewName("index");

        registro
                .addViewController("/index").setViewName("index");

        registro
                .addViewController("/login").setViewName("login");

        registro
                .addViewController("/registro/nuevo").setViewName("/registro/nuevo");
    }
//
////definir la autorizacion
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Deshabilitar CSRF para APIs REST
                .authorizeHttpRequests((request) -> request
                .requestMatchers("/", "/index", "/errores/**",
                        "/carrito/**", "/pruebas/**", "/reportes/**",
                        "/registro/**", "/js/**", "/webjars/**",
                        "/prueba-oracle/**", "/api/**", "/actuator/**",
                        "/css/**", "/images/**", "/static/**")
                .permitAll()
                .requestMatchers(
                        "/producto/nuevo", "/producto/guardar",
                        "/producto/modificar/**", "/producto/eliminar/**",
                        "/categoria/nueva", "/categoria/guardar",
                        "/categoria/modificar/**", "/categoria/eliminar/**",
                        "/usuario/nuevo", "/usuario/guardar",
                        "/usuario/modificar/**", "/usuario/eliminar/**",
                        "/reportes/**")
                .hasRole("ADMIN")
                .requestMatchers(
                        "/producto/listado",
                        "/categoria/listado",
                        "/usuario/listado")
                .hasAnyRole("ADMIN", "VENDEDOR")
                .requestMatchers("/facturar/carrito")
                .hasRole("USER")
                )
                .formLogin((form) -> form
                .loginPage("/login").permitAll()
                )
                .logout((logout) -> logout.permitAll())
                .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.sameOrigin())); // Para permitir iframes si es necesario

        return http.build();
    }
 //este metodo se usa esta semana pero se realizara un remplazo la siguiente semana

    @Bean
    public UserDetailsService users() {
        UserDetails admin, vendedor, usuario;

        admin = User.builder()
                .username("juan")
                .password("{noop}123")
                .roles("ADMIN", "VENDEDOR", "USER")
                .build();

        vendedor = User.builder()
                .username("rebeca")
                .password("{noop}456")
                .roles("VENDEDOR", "USER")
                .build();

        usuario = User.builder()
                .username("pedro")
                .password("{noop}789")
                .roles("USER")
                .build();

        return new InMemoryUserDetailsManager(admin, vendedor, usuario);
    }

    //Los siguientes elementos se requieren para hacer la autenticacion de usuarios con BD
    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    public void configurerGlobal(AuthenticationManagerBuilder build) throws Exception {
        build.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    } 

}
