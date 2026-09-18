/// Mapa de Departamentos del Perú con sus Provincias y Agencias BCP.
///
/// El departamento de Cusco contiene sus 13 provincias reales.
/// Los demás departamentos contienen 4 provincias de ejemplo (data simulada)
/// para demostrar la funcionalidad de selectores dependientes.
///
/// Cada provincia tiene 2-3 agencias BCP simuladas mapeadas.
class LocationData {
  static const Map<String, List<String>> departamentosConProvincias = {
    // ===== CUSCO - Data real completa (13 provincias) =====
    'Cusco': [
      'Cusco',
      'Acomayo',
      'Anta',
      'Calca',
      'Canas',
      'Canchis',
      'Chumbivilcas',
      'Espinar',
      'La Convención',
      'Paruro',
      'Paucartambo',
      'Quispicanchi',
      'Urubamba',
    ],

    // ===== Demás departamentos - Data simulada (4 provincias c/u) =====
    'Amazonas': ['Chachapoyas', 'Bagua', 'Bongará', 'Luya'],
    'Áncash': ['Huaraz', 'Santa', 'Yungay', 'Carhuaz'],
    'Apurímac': ['Abancay', 'Andahuaylas', 'Chincheros', 'Grau'],
    'Arequipa': ['Arequipa', 'Camaná', 'Caylloma', 'Islay'],
    'Ayacucho': ['Huamanga', 'Huanta', 'La Mar', 'Lucanas'],
    'Cajamarca': ['Cajamarca', 'Jaén', 'Chota', 'Cutervo'],
    'Callao': ['Callao', 'Bellavista', 'La Perla', 'Ventanilla'],
    'Huancavelica': ['Huancavelica', 'Acobamba', 'Angaraes', 'Tayacaja'],
    'Huánuco': ['Huánuco', 'Leoncio Prado', 'Ambo', 'Dos de Mayo'],
    'Ica': ['Ica', 'Chincha', 'Nazca', 'Pisco'],
    'Junín': ['Huancayo', 'Satipo', 'Tarma', 'Chanchamayo'],
    'La Libertad': ['Trujillo', 'Ascope', 'Pacasmayo', 'Sánchez Carrión'],
    'Lambayeque': ['Chiclayo', 'Ferreñafe', 'Lambayeque', 'Mochumí'],
    'Lima': ['Lima', 'Huaura', 'Cañete', 'Barranca'],
    'Loreto': ['Maynas', 'Alto Amazonas', 'Loreto', 'Requena'],
    'Madre de Dios': ['Tambopata', 'Manu', 'Tahuamanu', 'Las Piedras'],
    'Moquegua': ['Mariscal Nieto', 'General Sánchez Cerro', 'Ilo', 'Torata'],
    'Pasco': ['Pasco', 'Daniel Alcides Carrión', 'Oxapampa', 'Yanahuanca'],
    'Piura': ['Piura', 'Sullana', 'Talara', 'Paita'],
    'Puno': ['Puno', 'San Román', 'Azángaro', 'El Collao'],
    'San Martín': ['Moyobamba', 'San Martín', 'Rioja', 'Lamas'],
    'Tacna': ['Tacna', 'Candarave', 'Jorge Basadre', 'Tarata'],
    'Tumbes': ['Tumbes', 'Contralmirante Villar', 'Zarumilla', 'San Jacinto'],
    'Ucayali': ['Coronel Portillo', 'Atalaya', 'Padre Abad', 'Purús'],
  };

  /// Agencias BCP por provincia.
  /// Las provincias de Cusco tienen agencias más específicas.
  /// Las demás provincias tienen agencias genéricas simuladas.
  static const Map<String, List<String>> agenciasPorProvincia = {
    // ===== CUSCO - Agencias detalladas =====
    'Cusco': ['Agencia BCP Sol - Cusco', 'Agencia BCP Magisterio', 'Agencia BCP Wanchaq'],
    'Acomayo': ['Agencia BCP Acomayo Centro', 'Agencia BCP Acomayo Plaza'],
    'Anta': ['Agencia BCP Anta', 'Agencia BCP Izcuchaca'],
    'Calca': ['Agencia BCP Calca Centro', 'Agencia BCP Calca Plaza'],
    'Canas': ['Agencia BCP Yanaoca', 'Agencia BCP Canas Centro'],
    'Canchis': ['Agencia BCP Sicuani Centro', 'Agencia BCP Sicuani Mercado', 'Agencia BCP Marangani'],
    'Chumbivilcas': ['Agencia BCP Santo Tomás', 'Agencia BCP Chumbivilcas'],
    'Espinar': ['Agencia BCP Espinar Centro', 'Agencia BCP Yauri', 'Agencia BCP Espinar Mall'],
    'La Convención': ['Agencia BCP Quillabamba Centro', 'Agencia BCP Quillabamba Plaza', 'Agencia BCP Santa Ana'],
    'Paruro': ['Agencia BCP Paruro Centro', 'Agencia BCP Paruro Plaza'],
    'Paucartambo': ['Agencia BCP Paucartambo Centro', 'Agencia BCP Paucartambo Plaza'],
    'Quispicanchi': ['Agencia BCP Urcos', 'Agencia BCP Oropesa', 'Agencia BCP Quiquijana'],
    'Urubamba': ['Agencia BCP Urubamba Centro', 'Agencia BCP Ollantaytambo', 'Agencia BCP Valle Sagrado'],

    // ===== Demás provincias - Agencias genéricas =====
    'Chachapoyas': ['Agencia BCP Chachapoyas Centro', 'Agencia BCP Chachapoyas Plaza'],
    'Bagua': ['Agencia BCP Bagua Centro', 'Agencia BCP Bagua Grande'],
    'Bongará': ['Agencia BCP Jumbilla', 'Agencia BCP Bongará'],
    'Luya': ['Agencia BCP Lamud', 'Agencia BCP Luya Centro'],
    'Huaraz': ['Agencia BCP Huaraz Centro', 'Agencia BCP Huaraz Plaza', 'Agencia BCP Independencia'],
    'Santa': ['Agencia BCP Chimbote Centro', 'Agencia BCP Nuevo Chimbote'],
    'Yungay': ['Agencia BCP Yungay Centro', 'Agencia BCP Yungay Plaza'],
    'Carhuaz': ['Agencia BCP Carhuaz Centro', 'Agencia BCP Carhuaz Plaza'],
    'Abancay': ['Agencia BCP Abancay Centro', 'Agencia BCP Abancay Plaza', 'Agencia BCP Tamburco'],
    'Andahuaylas': ['Agencia BCP Andahuaylas Centro', 'Agencia BCP Andahuaylas Plaza'],
    'Chincheros': ['Agencia BCP Chincheros Centro', 'Agencia BCP Chincheros Plaza'],
    'Grau': ['Agencia BCP Chuquibambilla', 'Agencia BCP Grau Centro'],
    'Arequipa': ['Agencia BCP Arequipa Centro', 'Agencia BCP Cayma', 'Agencia BCP Cerro Colorado'],
    'Camaná': ['Agencia BCP Camaná Centro', 'Agencia BCP Camaná Plaza'],
    'Caylloma': ['Agencia BCP Chivay', 'Agencia BCP Caylloma Centro'],
    'Islay': ['Agencia BCP Mollendo', 'Agencia BCP Mejía'],
    'Huamanga': ['Agencia BCP Ayacucho Centro', 'Agencia BCP Ayacucho Plaza', 'Agencia BCP San Juan Bautista'],
    'Huanta': ['Agencia BCP Huanta Centro', 'Agencia BCP Huanta Plaza'],
    'La Mar': ['Agencia BCP San Miguel', 'Agencia BCP La Mar Centro'],
    'Lucanas': ['Agencia BCP Puquio', 'Agencia BCP Lucanas Centro'],
    'Cajamarca': ['Agencia BCP Cajamarca Centro', 'Agencia BCP Cajamarca Plaza', 'Agencia BCP Baños del Inca'],
    'Jaén': ['Agencia BCP Jaén Centro', 'Agencia BCP Jaén Plaza'],
    'Chota': ['Agencia BCP Chota Centro', 'Agencia BCP Chota Plaza'],
    'Cutervo': ['Agencia BCP Cutervo Centro', 'Agencia BCP Cutervo Plaza'],
    'Callao': ['Agencia BCP Callao Centro', 'Agencia BCP La Punta', 'Agencia BCP Callao Mall'],
    'Bellavista': ['Agencia BCP Bellavista Centro', 'Agencia BCP Bellavista Plaza'],
    'La Perla': ['Agencia BCP La Perla Centro', 'Agencia BCP La Perla Plaza'],
    'Ventanilla': ['Agencia BCP Ventanilla Centro', 'Agencia BCP Mi Perú'],
    'Huancavelica': ['Agencia BCP Huancavelica Centro', 'Agencia BCP Huancavelica Plaza'],
    'Acobamba': ['Agencia BCP Acobamba Centro', 'Agencia BCP Acobamba Plaza'],
    'Angaraes': ['Agencia BCP Lircay', 'Agencia BCP Angaraes Centro'],
    'Tayacaja': ['Agencia BCP Pampas', 'Agencia BCP Tayacaja Centro'],
    'Huánuco': ['Agencia BCP Huánuco Centro', 'Agencia BCP Huánuco Plaza', 'Agencia BCP Amarilis'],
    'Leoncio Prado': ['Agencia BCP Tingo María Centro', 'Agencia BCP Tingo María Plaza'],
    'Ambo': ['Agencia BCP Ambo Centro', 'Agencia BCP Ambo Plaza'],
    'Dos de Mayo': ['Agencia BCP La Unión', 'Agencia BCP Dos de Mayo Centro'],
    'Ica': ['Agencia BCP Ica Centro', 'Agencia BCP Ica Plaza', 'Agencia BCP Ica Mall'],
    'Chincha': ['Agencia BCP Chincha Alta', 'Agencia BCP Chincha Plaza'],
    'Nazca': ['Agencia BCP Nazca Centro', 'Agencia BCP Nazca Plaza'],
    'Pisco': ['Agencia BCP Pisco Centro', 'Agencia BCP Pisco Plaza'],
    'Huancayo': ['Agencia BCP Huancayo Centro', 'Agencia BCP Real Plaza Huancayo', 'Agencia BCP El Tambo'],
    'Satipo': ['Agencia BCP Satipo Centro', 'Agencia BCP Satipo Plaza'],
    'Tarma': ['Agencia BCP Tarma Centro', 'Agencia BCP Tarma Plaza'],
    'Chanchamayo': ['Agencia BCP La Merced', 'Agencia BCP San Ramón'],
    'Trujillo': ['Agencia BCP Trujillo Centro', 'Agencia BCP Mall Aventura Trujillo', 'Agencia BCP El Porvenir'],
    'Ascope': ['Agencia BCP Ascope Centro', 'Agencia BCP Casa Grande'],
    'Pacasmayo': ['Agencia BCP Pacasmayo Centro', 'Agencia BCP San Pedro'],
    'Sánchez Carrión': ['Agencia BCP Huamachuco', 'Agencia BCP Sánchez Carrión Centro'],
    'Chiclayo': ['Agencia BCP Chiclayo Centro', 'Agencia BCP Real Plaza Chiclayo', 'Agencia BCP La Victoria'],
    'Ferreñafe': ['Agencia BCP Ferreñafe Centro', 'Agencia BCP Ferreñafe Plaza'],
    'Lambayeque': ['Agencia BCP Lambayeque Centro', 'Agencia BCP Lambayeque Plaza'],
    'Mochumí': ['Agencia BCP Mochumí Centro', 'Agencia BCP Mochumí Plaza'],
    'Lima': ['Agencia BCP Lima Centro', 'Agencia BCP Miraflores', 'Agencia BCP San Isidro'],
    'Huaura': ['Agencia BCP Huacho', 'Agencia BCP Huaura Centro'],
    'Cañete': ['Agencia BCP San Vicente', 'Agencia BCP Cañete Centro'],
    'Barranca': ['Agencia BCP Barranca Centro', 'Agencia BCP Barranca Plaza'],
    'Maynas': ['Agencia BCP Iquitos Centro', 'Agencia BCP Iquitos Plaza', 'Agencia BCP San Juan'],
    'Alto Amazonas': ['Agencia BCP Yurimaguas', 'Agencia BCP Alto Amazonas Centro'],
    'Loreto': ['Agencia BCP Nauta', 'Agencia BCP Loreto Centro'],
    'Requena': ['Agencia BCP Requena Centro', 'Agencia BCP Requena Plaza'],
    'Tambopata': ['Agencia BCP Puerto Maldonado Centro', 'Agencia BCP Puerto Maldonado Plaza'],
    'Manu': ['Agencia BCP Salvación', 'Agencia BCP Manu Centro'],
    'Tahuamanu': ['Agencia BCP Iñapari', 'Agencia BCP Tahuamanu Centro'],
    'Las Piedras': ['Agencia BCP Las Piedras Centro', 'Agencia BCP Planchón'],
    'Mariscal Nieto': ['Agencia BCP Moquegua Centro', 'Agencia BCP Moquegua Plaza'],
    'General Sánchez Cerro': ['Agencia BCP Omate', 'Agencia BCP Sánchez Cerro Centro'],
    'Ilo': ['Agencia BCP Ilo Centro', 'Agencia BCP Ilo Plaza'],
    'Torata': ['Agencia BCP Torata Centro', 'Agencia BCP Torata Plaza'],
    'Pasco': ['Agencia BCP Cerro de Pasco Centro', 'Agencia BCP Cerro de Pasco Plaza'],
    'Daniel Alcides Carrión': ['Agencia BCP Yanahuanca', 'Agencia BCP D.A. Carrión Centro'],
    'Oxapampa': ['Agencia BCP Oxapampa Centro', 'Agencia BCP Oxapampa Plaza'],
    'Yanahuanca': ['Agencia BCP Yanahuanca Centro', 'Agencia BCP Yanahuanca Plaza'],
    'Piura': ['Agencia BCP Piura Centro', 'Agencia BCP Real Plaza Piura', 'Agencia BCP Castilla'],
    'Sullana': ['Agencia BCP Sullana Centro', 'Agencia BCP Sullana Plaza'],
    'Talara': ['Agencia BCP Talara Centro', 'Agencia BCP Talara Plaza'],
    'Paita': ['Agencia BCP Paita Centro', 'Agencia BCP Paita Plaza'],
    'Puno': ['Agencia BCP Puno Centro', 'Agencia BCP Puno Plaza', 'Agencia BCP Puno Mall'],
    'San Román': ['Agencia BCP Juliaca Centro', 'Agencia BCP Juliaca Plaza', 'Agencia BCP Real Plaza Juliaca'],
    'Azángaro': ['Agencia BCP Azángaro Centro', 'Agencia BCP Azángaro Plaza'],
    'El Collao': ['Agencia BCP Ilave', 'Agencia BCP El Collao Centro'],
    'Moyobamba': ['Agencia BCP Moyobamba Centro', 'Agencia BCP Moyobamba Plaza'],
    'San Martín': ['Agencia BCP Tarapoto Centro', 'Agencia BCP Tarapoto Plaza'],
    'Rioja': ['Agencia BCP Rioja Centro', 'Agencia BCP Nueva Cajamarca'],
    'Lamas': ['Agencia BCP Lamas Centro', 'Agencia BCP Lamas Plaza'],
    'Tacna': ['Agencia BCP Tacna Centro', 'Agencia BCP Tacna Plaza', 'Agencia BCP Alto de la Alianza'],
    'Candarave': ['Agencia BCP Candarave Centro', 'Agencia BCP Candarave Plaza'],
    'Jorge Basadre': ['Agencia BCP Locumba', 'Agencia BCP Jorge Basadre Centro'],
    'Tarata': ['Agencia BCP Tarata Centro', 'Agencia BCP Tarata Plaza'],
    'Tumbes': ['Agencia BCP Tumbes Centro', 'Agencia BCP Tumbes Plaza'],
    'Contralmirante Villar': ['Agencia BCP Zorritos', 'Agencia BCP C. Villar Centro'],
    'Zarumilla': ['Agencia BCP Zarumilla Centro', 'Agencia BCP Aguas Verdes'],
    'San Jacinto': ['Agencia BCP San Jacinto Centro', 'Agencia BCP San Jacinto Plaza'],
    'Coronel Portillo': ['Agencia BCP Pucallpa Centro', 'Agencia BCP Pucallpa Plaza', 'Agencia BCP Manantay'],
    'Atalaya': ['Agencia BCP Atalaya Centro', 'Agencia BCP Atalaya Plaza'],
    'Padre Abad': ['Agencia BCP Aguaytía', 'Agencia BCP Padre Abad Centro'],
    'Purús': ['Agencia BCP Puerto Esperanza', 'Agencia BCP Purús Centro'],
  };

  /// Retorna la lista de departamentos ordenados alfabéticamente.
  static List<String> get departamentos {
    final deps = departamentosConProvincias.keys.toList();
    deps.sort();
    return deps;
  }

  /// Retorna las provincias para un departamento dado.
  static List<String> getProvincias(String departamento) {
    return departamentosConProvincias[departamento] ?? [];
  }

  /// Retorna las agencias BCP para una provincia dada.
  static List<String> getAgencias(String provincia) {
    return agenciasPorProvincia[provincia] ?? ['Agencia BCP $provincia'];
  }
}
