<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:px="urn:panax">
  <xsl:template match="Voluntario[lang('es')]" mode="headerText">Voluntario</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Nombre[1]" mode="headerText">Nombre(s)</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ApellidoPaterno[1]" mode="headerText">Apellido Paterno</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ApellidoMaterno[1]" mode="headerText">Apellido Materno</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Apodo[1]" mode="headerText">¿Cómo te gusta que te digan?</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Sexo[1]" mode="headerText">Sexo</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/esServicioSocial[1]" mode="headerText">¿Estarás haciendo tu servicio social en ésta institución?</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ActividadesDeInteres[1]" mode="headerText">¿Te gustaría involucrarte más en las actividades de ésta institución? </xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/FechaIntegracion[1]" mode="headerText">Fecha de integración a actividades de ésta asociación</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/AnioIntegracion[1]/Anio" mode="headerText">Año</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/UltimoEquipo[1]" mode="headerText">Último Equipo</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/FechaNacimiento[1]" mode="headerText">Fecha Nacimiento</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionNacimiento" mode="headerText">Ciudad de Nacimiento</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/AnioNacimiento[1]" mode="headerText">Año</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MesNacimiento[1]" mode="headerText">Mes</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/DiaNacimiento[1]" mode="headerText">Dia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/DiaNacimiento[1]" mode="emptyText">Dia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PaisResidencia[1]" mode="headerText">País de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtroPaisResidencia[1]" mode="headerText"></xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtroPaisResidencia[1]" mode="emptyText">Escriba cuál país</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/EstadoResidencia[1]" mode="headerText">Estado de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MunicipioResidencia[1]" mode="headerText">Municipio de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia[1]" mode="headerText">País de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia//Pais" mode="headerText">País de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia//Estado" mode="headerText">Estado de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia//Municipio" mode="headerText">Municipio de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia/*" mode="headerText">Poblacion de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/PoblacionResidencia[1]" mode="emptyText">Población</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtraPoblacionResidencia[1]" mode="headerText">Población de Residencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Foto[1]" mode="headerText">Foto</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Trabajas[1]" mode="headerText">Trabajas</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/LugarTrabajo[1]" mode="headerText">Lugar Trabajo</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Empleador[1]" mode="headerText">Nombre del Jefe</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Telefono[1]" mode="headerText">Telefono</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Estudias[1]" mode="headerText">Estudias</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Institucion[1]" mode="headerText">Institución Académica</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Calle[1]" mode="headerText">Calle</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NumeroExterior[1]" mode="headerText">Número Exterior</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NumeroInterior[1]" mode="headerText">Número Interior</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Colonia[1]" mode="headerText">Colonia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/CP[1]" mode="headerText">CP</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Referencias[1]" mode="headerText">Referencias</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Ciudad[1]" mode="headerText">Ciudad</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/LadaCasa[1]" mode="headerText">Lada</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/TelefonoCasa[1]" mode="headerText">Número</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NoTengoTelefono[1]" mode="headerText">No tengo teléfono</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Celular[1]" mode="headerText">Celular</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NoTengoCelular[1]" mode="headerText">No tengo celular</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/LadaOficina[1]" mode="headerText">Lada</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/TelefonoOficina[1]" mode="headerText">Teléfono</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/CorreoElectronico[1]" mode="headerText">Correo Electrónico</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Dominio[1]" mode="headerText">Dominio</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtroDominioCorreo[1]" mode="headerText">Dominio</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Facebook[1]" mode="headerText">Facebook</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Facebook[1]" mode="emptyText"></xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/DominioFacebook[1]" mode="headerText">Dominio Facebook</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Twitter[1]" mode="headerText">Twitter</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/GradoEstudios[1]" mode="headerText">Grado de Estudios</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/EstadoCivilPadres[1]" mode="headerText">Estado Civil de los Padres</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Religion[1]" mode="headerText">Religión</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ViveTuPapa[1]" mode="headerText">Vive tu Papá</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ViveTuMama[1]" mode="headerText">Vive tu Mamá</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NumeroDeHermanos[1]" mode="headerText">Número De Hermanos</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/HermanosVoluntario[1]" mode="headerText">Nombres Hermanos</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Nombres[1]" mode="headerText">Nombres</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/ContactoDeEmergencia[1]" mode="headerText">Contacto De Emergencia</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/NombreContactoEmergencia[1]" mode="headerText">Nombre</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/TelefonoCasaContactoEmergencia[1]" mode="headerText">Teléfono de casa</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/CelularContactoEmergencia[1]" mode="headerText">Celular</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtroTelefonoContactoEmergencia[1]" mode="headerText">Otro Teléfono</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MedioCaptacion[1]" mode="headerText">¿Cómo te enteraste de esta asociación?</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/OtroMedioCaptacion[1]" mode="headerText">¿Cuál otro medio?</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MedioCaptacion[1]/*" mode="emptyText">Selecciona una opción</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MotivoDeInteres[1]" mode="headerText">¿Porqué te interesa involucrarte?</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/TipoSangre[1]" mode="headerText">Tipo de Sangre</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Alergias[1]" mode="headerText">Alergias</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MedicamentosContraindicados[1]" mode="headerText">Medicamentos que no puedes recibir</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/RestriccionesMedicas[1]" mode="headerText">Restricciones Médicas</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/MedicamentoPeriodico[1]" mode="headerText">Tomas algún medicamento periódicamente</xsl:template>
  <xsl:template match="Voluntario[lang('es')]/px:fields/Evento[1]" mode="headerText">Evento</xsl:template>

  <xsl:template match="PersonaConDiscapacidad[lang('es')]" mode="headerText">Persona Con Discapacidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ProporcionanteDatos" mode="headerText">¿Quién Proporciona los Datos?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroProporcionanteDatos" mode="headerText">¿Quién?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Nombre" mode="headerText">Nombre(s)</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ApellidoPaterno" mode="headerText">Apellido Paterno</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ApellidoMaterno" mode="headerText">Apellido Materno</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Apodo[1]" mode="headerText">¿Cómo te gusta que te digan?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Apodo[1]" mode="emptyText">Apodo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/FechaDeNacimiento" mode="headerText">Fecha de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AnioNacimiento[1]" mode="headerText">Año</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MesNacimiento[1]" mode="headerText">Mes</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DiaNacimiento[1]" mode="headerText">Dia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Sexo" mode="headerText">Sexo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstadoCivil" mode="headerText">Estado Civil</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MedioCaptacion[1]" mode="headerText">¿Cómo te enteraste de esta asociación?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MedioCaptacion[1]/*" mode="emptyText">Selecciona una opción</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroMedioCaptacion[1]" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MotivoDeInteres[1]" mode="headerText">¿Porqué te interesa involucrarte?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TrabajaConNosotros" mode="headerText">¿Es Voluntario, Staff o trabaja con nosotros?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoTrabajoConNosotros" mode="headerText">¿Qué otra actividad realiza con nosotros?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoTrabajoConNosotrosComentarios" mode="headerText">Comentarios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PorcentajeBecaSugerido" mode="headerText">Porc. de Beca Sugerido</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PorcentajeBecaOtorgado" mode="headerText">Porc. de Beca Otorgada</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AnioIntegracion" mode="headerText">Año de integración a actividades de ésta asociación</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UltimoEquipo" mode="headerText">Ultimo Equipo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PaisNacimiento" mode="headerText">País de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstadoNacimiento" mode="headerText">Estado de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MunicipioNacimiento" mode="headerText">Municipio de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionNacimiento" mode="headerText">Ciudad de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionNacimiento//Pais" mode="headerText">País de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionNacimiento//Estado" mode="headerText">Estado de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionNacimiento//Municipio" mode="headerText">Municipio de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionNacimiento//Ciudad" mode="headerText">Ciudad de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtraPoblacionNacimiento" mode="headerText">Población de Nacimiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroPaisNacimiento[1]" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroPaisNacimiento[1]" mode="emptyText">Escriba cuál país</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroPaisResidencia[1]" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroPaisResidencia[1]" mode="emptyText">Escriba cuál país</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstadoResidencia[1]" mode="headerText">Estado de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MunicipioResidencia[1]" mode="headerText">Municipio de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia[1]" mode="headerText">País de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia//Pais" mode="headerText">País de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia//Estado" mode="headerText">Estado de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia//Municipio" mode="headerText">Municipio de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia/*" mode="headerText">Poblacion de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PoblacionResidencia[1]" mode="emptyText">Población</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtraPoblacionResidencia[1]" mode="headerText">Población de Residencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Foto" mode="headerText">Foto</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Trabaja" mode="headerText">Trabaja</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Empresa" mode="headerText">Empresa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Empleador[1]" mode="headerText">Nombre del Jefe</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoEmpresa" mode="headerText">Teléfono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TrabajoAntes" mode="headerText">Ha trabajado antes</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuestoReciente" mode="headerText">Puesto 1 más Reciente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TurnoReciente" mode="headerText">Turno</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpresaReciente" mode="headerText">Empresa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpleadorReciente" mode="headerText">Nombre del Jefe</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoEmpresaReciente" mode="headerText">Teléfono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuestoReciente2" mode="headerText">Puesto 2 más reciente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TurnoReciente2" mode="headerText">Turno</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpresaReciente2" mode="headerText">Empresa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpleadorReciente2" mode="headerText">Nombre del Jefe</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoEmpresaReciente2" mode="headerText">Teléfono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstatusHabitacion" mode="headerText">La casa donde habita actualmente es</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoVivienda" mode="headerText">Tipo de vivienda</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroDormitorios" mode="headerText">Número de dormitorios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroSalas" mode="headerText">Número de salas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroComedores" mode="headerText">Número de comedores</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroCocinas" mode="headerText">Número de cocinas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/BaniosCompletos" mode="headerText">Baños completos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MediosBanios" mode="headerText">Medios baños</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ServiciosDomicilio" mode="headerText">Servicios Domicilio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Calle" mode="headerText">Calle</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroExterior" mode="headerText">Número Exterior</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroInterior" mode="headerText">Número Interior</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Colonia" mode="headerText">Colonia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CP" mode="headerText">CP</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Referencias" mode="headerText">Referencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Ciudad" mode="headerText">Ciudad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaCasa" mode="emptyText">Lada</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaCasa" mode="headerText">Lada Casa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoCasa" mode="headerText">Teléfono Casa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoCasa" mode="emptyText">Número</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NoTieneTelefono[1]" mode="headerText">No tiene teléfono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Celular" mode="headerText">Celular</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NoTieneCelular[1]" mode="headerText">No tiene celular</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaOficina" mode="emptyText">Lada</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoOficina" mode="headerText">Teléfono Oficina</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoOficina" mode="emptyText">Número</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CorreoElectronico" mode="headerText">Correo Electrónico</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NoTieneCorreo[1]" mode="headerText">No tiene correo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Dominio" mode="headerText">Dominio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Facebook" mode="headerText">Facebook</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DominioFacebook" mode="headerText">Dominio Facebook</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Twitter" mode="headerText">Twitter</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SeTransportaSolo" mode="headerText">Se transporta de manera independiente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CuandoSeTransportaSoloActividades" mode="headerText">Se transportará solo a las actividades</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoTransporte" mode="headerText">Generalmente en qué se transporta la persona</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Escuela" mode="headerText">Institución a la que asiste</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/GradoEstudios" mode="headerText">Grado de Estudios alcanzado</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/GradoEstudioPxncluso" mode="headerText">Tiene algún grado de estudios sin concluír</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstudiaActualmente" mode="headerText">Estudia Actualmente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstudiosActuales" mode="headerText">Grado</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/InstitucionActual" mode="headerText">Institucion</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Religion" mode="headerText">Religion</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Comulga" mode="headerText">Comulga</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HabitantesDomicilioPcD" mode="headerText">Número de personas que viven en el domicilio de la persona con discapacidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/VivePadre" mode="headerText">Vive el Padre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NombrePadre" mode="headerText">Nombre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CelularPadre" mode="headerText">Celular</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmailPadre" mode="headerText">Email</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DominioEmailPadre" mode="headerText">dominio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmailMadre" mode="headerText">Email</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DominioEmailMadre" mode="headerText">dominio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PadreTieneTrabajoRemunerado" mode="headerText">Tiene trabajo remunerado</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpresaPadre" mode="headerText">Empresa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuestoPadre" mode="headerText">Puesto</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DomicilioTrabajoPadre" mode="headerText">Domicilio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaTrabajoPadre" mode="headerText">Telefono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaTrabajoPadre" mode="emptyText">Lada</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoTrabajoPadre" mode="headerText">Teléfono Trabajo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoTrabajoPadre" mode="emptyText">Número</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ViveMadre" mode="headerText">Vive la Madre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NombreMadre" mode="headerText">Nombre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CelularMadre" mode="headerText">Celular</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MadreTieneTrabajoRemunerado" mode="headerText">Tiene trabajo remunerado</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EmpresaMadre" mode="headerText">Empresa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuestoMadre" mode="headerText">Puesto</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DomicilioTrabajoMadre" mode="headerText">Domicilio</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaTrabajoMadre" mode="headerText">Telefono</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LadaTrabajoMadre" mode="emptyText">Lada</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoTrabajoMadre" mode="headerText">Teléfono Trabajo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoTrabajoMadre" mode="emptyText">Número</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstadoCivilPadres" mode="headerText">Estado civil de los Padres</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PapaAutorizado" mode="headerText">Papá</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MamaAutorizada" mode="headerText">Mamá</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HermanosAutorizado" mode="headerText">Hermanos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroAutorizado" mode="headerText">Otro</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Persona1Autorizada" mode="headerText">Nombre Persona 1</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ParentescoPersona1" mode="headerText">Parentesco</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Persona2Autorizada" mode="headerText">Nombre Persona 2</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ParentescoPersona2" mode="headerText">Parentesco</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroSueldos" mode="headerText">Número de sueldos que mantienen la casa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroHermanos" mode="headerText">Número de hermanos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ContactoDeEmergencia" mode="headerText">Contacto De Emergencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NombreContactoEmergencia" mode="headerText">Nombre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TelefonoCasaContactoEmergencia" mode="headerText">Teléfono Casa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CelularContactoEmergencia" mode="headerText">Celular</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroTelefonoContacto" mode="headerText">Teléfono Contacto</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DescripcionDia" mode="headerText">Descripción breve de un día de la persona con discapacidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Capturista" mode="headerText">Quién captura los datos de éste expediente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ServicioMedico" mode="headerText">Servicios médicos con que cuenta la familia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CuentaConSeguroGMM" mode="headerText">Cuenta Con SGMM</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoCoberturaGMM" mode="headerText">Tipo de Cobertura</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Aseguradora" mode="headerText">Aseguradora</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/NumeroPoliza" mode="headerText">Número de Póliza</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EdadAdquirida" mode="headerText">Edad Adquirida</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionFamiliaAnteDiscapacidad" mode="headerText">Reacción Familia ante Discapacidad del Miembro</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DiagnosticoNo1" mode="headerText">Diagnostico No. 1</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/DiagnosticoNo2" mode="headerText">Diagnostico No. 2</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Tratamiento" mode="headerText">Tratamiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Pronostico" mode="headerText">Pronóstico</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HaRecibidoServiciosProfesionales" mode="headerText">¿Ha recibido alguno de los siguientes servicios?  </xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TieneOtraEnfermedad" mode="headerText">Otra Enfermedad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtraEnfermedad" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/BreveDescripcionEnfermedad" mode="headerText">Breve descripción</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HayAlimentosNoDebeIngerir" mode="headerText">Hay Alimentos que no debe ingerir</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AlimentosNoDebeIngerir" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionMedicaAlimentos" mode="headerText">¿Reacción médica?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TratamientoAlimentos" mode="headerText">Tratamiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HayBebidasNoDebeIngerir" mode="headerText">Hay bebidas que no debe ingerir</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/BebidasNoDebeIngerir" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionMedicaBebidas" mode="headerText">¿Reacción médica?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TratamientoBebidas" mode="headerText">Tratamiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Peso" mode="headerText">Peso</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Estatura" mode="headerText">Estatura</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CondicionFisica" mode="headerText">Condición Física</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoSangre" mode="headerText">Tipo de sangre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionMedicaActividadesFisicas" mode="headerText">Reacción médica al realizar actividad física</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionBajoElSol" mode="headerText">Reacción al estar bajo sol</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionEmocionesFuertes" mode="headerText">Reacción a las emociones fuertes</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HaEstadoHospitalizado" mode="headerText">Ha estado hospitalizado</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CausaHospitalizacion" mode="headerText">Causa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TiempoHospitalizacion" mode="headerText">Tiempo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EdadHospitalizacion" mode="headerText">Edad en la que estuvo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComentariosHospitalizacion" mode="headerText">Comentarios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SostieneLaCabezaSolo" mode="headerText">Sostiene la cabeza por sí solo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SostieneLaCabezaSoloComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SostieneLaCabezaSoloComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaSondaParaComer" mode="headerText">Utiliza sonda para comer</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaSondaParaBanio" mode="headerText">Utiliza sonda para ir al baño</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComentariosUtilizaSondaParaComer" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComentariosUtilizaSondaParaBanio" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComentariosUtilizaSondaParaComer" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComentariosUtilizaSondaParaBanio" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/IndicacionesParaComer" mode="headerText">Indicaciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PrevencionesParaComer" mode="headerText">Prevenciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/IndicacionesParaBanio" mode="headerText">Indicaciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PrevencionesParaBanio" mode="headerText">Prevenciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReconoceLasPersonas" mode="headerText">Reconoce a las personas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReconoceLasPersonasComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReconoceLasPersonasComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComePorSiSolo" mode="headerText">Come por si solo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComePorSiSoloComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComePorSiSoloComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaSalivacion" mode="headerText">Presenta salivacion, babea</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaSalivacionComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaSalivacionComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTics" mode="headerText">Presenta Tics o movimientos involuntarios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CualesTicsPresenta" mode="headerText">¿Cuáles?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTicsComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTicsComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaMarcapasos" mode="headerText">Utiliza marcapasos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaMarcapasosRestricciones" mode="headerText">Restricciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaMarcapasosComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaMarcapasosComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaProtesis" mode="headerText">Utiliza prótesis</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaProtesisComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaProtesisComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TipoProtesis" mode="headerText">¿De qué tipo? </xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/RestriccionesProtesis" mode="headerText">Restricciones Protesis</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaAparatos" mode="headerText">¿Utiliza aparatos que le ayudan a moverse?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaAparatosComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UtilizaAparatosComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtroAparato" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosVista" mode="headerText">Presenta transtornos de la vista</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosVistaComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosVistaComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosAudicion" mode="headerText">Presenta trastornos de la audición</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosAudicionComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaTranstornosAudicionComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaEnfermedadesInfecciosas" mode="headerText">Presenta enfermedades infecciosas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaEnfermedadesInfecciosasComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaEnfermedadesInfecciosasComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EnfermedadesInfecciosas" mode="headerText">¿Cuáles?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaConvulsiones" mode="headerText">Presenta Convulsiones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaConvulsionesComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaConvulsionesComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CaracteristicasPreviasConvulsion" mode="headerText">Características previas a la convulsión</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/FrecuenciaConvulsiones" mode="headerText">Frecuencia</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TratamientoConvulsiones" mode="headerText">Tratamiento</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/VaAlBanioPorSiSolo" mode="headerText">Va al baño por si solo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/VaAlBanioPorSiSoloRecomendacion" mode="headerText">Recomendación</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CuidadoEspecialPeriodo" mode="headerText">Debe tener algún cuidado especial al presentar su periodo menstrual</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CualCuidadoEspecial" mode="headerText">¿Cuáles?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SintomasPeriodo" mode="headerText">¿Síntomas?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AyudaEnElBanio" mode="headerText">¿Necesita ayuda en el baño? ¿De qué tipo?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MantieneContactoVisual" mode="headerText">Mantiene contacto visual con las personas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MantieneContactoVisualComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MantieneContactoVisualComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ImitaSonidos" mode="headerText">Puede imitar sonidos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ImitaSonidosComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ImitaSonidosComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/FormulaFrases" mode="headerText">Es capaz de formular frases u oraciones</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/FormulaFrasesComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/FormulaFrasesComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SeAdaptaAlClima" mode="headerText">Se adapta a los cambios de clima</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SeAdaptaAlClimaComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SeAdaptaAlClimaComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionaConSuNombre" mode="headerText">Reacciona al escuchar su nombre</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionaConSuNombreComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ReaccionaConSuNombreComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MantieneBuenaRelacionConPadres" mode="headerText">Mantiene una buena relación con sus papás</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MantieneBuenaRelacionConHermanos" mode="headerText">Mantiene una buena relación con sus hermanos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuedePermanecerSinTutores" mode="headerText">Puede permanecer SIN sus papás o tutores</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuedePermanecerSinTutoresComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuedePermanecerSinTutoresComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PlaticaConOtrasPersonas" mode="headerText">Platica con otras personas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PlaticaConOtrasPersonasComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PlaticaConOtrasPersonasComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ComportamientoGrupo" mode="headerText">Comportamiento en grupo</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AbordajeTemaSexual" mode="headerText">Abordaje de la familia hacia el tema de la sexualidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AbordajeTemaSexualDescripcion" mode="headerText">Descripción</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ManifiestaAgresividad" mode="headerText">Manifiesta agresividad hacia otras personas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ManifiestaAgresividadComentarios" mode="headerText">Comentarios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ManifiestaAgresividadComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ManifiestaAgresividadComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaArranquesDeFuria" mode="headerText">Presenta arranques de furia o irritabilidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaArranquesDeFuriaComentarios" mode="headerText">Comentarios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaArranquesDeFuriaComentarios" mode="headerText"></xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PresentaArranquesDeFuriaComentarios" mode="emptyText">Escribe aquí tus comentarios o sugerencias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstimulosQueLeMolestan" mode="headerText">Le molesta algún tipo de estímulo: Visual, auditivo, táctil, espacios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/CualEstimuloLeMolestan" mode="headerText">Ejemplos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ConductasAMejorar" mode="headerText">Conductas a mejorar</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SuenioMasGrande1" mode="headerText">Sueño mas grande 1</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SuenioMasGrande2" mode="headerText">Sueño mas grande 2</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PuedeSalirConAmigosDeNoche" mode="headerText">Puede salir con sus amigos por la noche</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Fuma" mode="headerText">Fuma</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TomaBebidasAlcoholicas" mode="headerText">Toma bebidas alcohólicas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PermisoParaDormirFueraDeCasa" mode="headerText">Tiene permiso de dormir en otro lugar que no sea su casa</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/EstacionFavorita" mode="headerText">Estación de radio favorita</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtraEstacionFavorita" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ProgramaTVFavorito" mode="headerText">Programa de TV favorito</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/MusicaFavorita" mode="headerText">Música Favorita</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/OtraMusicaFavorita" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ArtistaFavorito" mode="headerText">Artista Favorito</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Talento1" mode="headerText">Talento 1</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Talento2" mode="headerText">Talento 2</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/GustaDeAnimales" mode="headerText">Le gustan los animales</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AnimalFavorito1" mode="headerText">Animal favorito 1</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AnimalFavorito2" mode="headerText">Animal favorito 2</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/TemeAnimales" mode="headerText">Tiene miedo a algún animal</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AnimalQueTeme" mode="headerText">¿Cuál?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/LeGustaElAgua" mode="headerText">Le gusta el agua</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/SabeNadar" mode="headerText">Sabe nadar</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PermisoParaNadar" mode="headerText">Tiene permiso de meterse al agua</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/UsaAlgoParaFlotar" mode="headerText">Usa algo para flotar</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/IndicacionesGeneralesParaNadar" mode="headerText">Indicaciones generales para nadar</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/PermisoParaSubirAToboganes" mode="headerText">Tiene permiso de subir a toboganes</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ActividadesFavoritas" mode="headerText">Top 4 de Actividades Favoritas</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ActividadesPeriodicas" mode="headerText">Asiste a alguna actividad periódicamente</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Alergias" mode="headerText">Alergias</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/AlmentosNoDebeIngerir" mode="headerText">Almentos que no debe Ingerir</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Aspiraciones" mode="headerText">Le gustaría</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Discapacidades" mode="headerText">Discapacidades</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Enfermedades" mode="headerText">Enfermedades</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Hermanos" mode="headerText">Nombres</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/HorariosLibresActividades" mode="headerText">Horarios que tiene libres para realizar actividades</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Ingresos" mode="headerText">Ingresos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Medicamentos" mode="headerText">Medicamentos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/Personalidad" mode="headerText">Personalidad</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ServiciosDomicilioPcD" mode="headerText">Cuenta con los siguientes servicios</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:fields/ServiciosRecibidos" mode="headerText">Servicios Recibidos</xsl:template>
  
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='TrabajoAntes']" mode="headerText">Ha trabajado antes</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='AlimentosNoIngerir']" mode="headerText">Hay alimentos que NO deba ingerir</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='BebidasNoIngerir']" mode="headerText">Hay bebidas que NO deba ingerir</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='GrandesSueños']" mode="headerText">¿Cuáles son sus dos más grandes sueños?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='Talentos']" mode="headerText">Nombra 2 talentos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='AnimalesFavoritos']" mode="headerText">Animal o mascota favoritos</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='CuantosTiene']" mode="headerText">¿Cuántos tiene tu casa?</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='DatosPadres']" mode="headerText">Información de los padres</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldSet[@name='PersonasAutorizadas']" mode="headerText">Personas autorizadas para recoger al participante</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='Personas Autorizadas']" mode="headerText">Otro</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='OtroContacto']" mode="headerText">Otro Contacto</xsl:template>
  <xsl:template match="PersonaConDiscapacidad[lang('es')]/px:layout//px:fieldContainer[@name='CuentaConSeguroGMM']" mode="headerText">Cuenta con Seguro de gastos Médicos Mayores</xsl:template>

    <xsl:template match="px:fieldContainer[@name='AsignacionesDeGrupos']" mode="headerText">Asignaciones de grupos</xsl:template>
</xsl:stylesheet>