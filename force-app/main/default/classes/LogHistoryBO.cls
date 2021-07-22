public with sharing class LogHistoryBO {
    
	public static boolean skipLog = false;
	public static void createLog(String objName, String action, List<SObject> lst, Map<Id,Object> mapOld){
		List<History__c> lstLog = new  List<History__c>();
		for(SObject item :lst){
			lstLog.addAll(gerarLogAlteracao(objName, 
				action,
				String.valueOf(item.get('Id')), 
				item, 
				(action != 'Insert'? mapOld.get(String.valueOf(item.get('Id'))) : null )));			
		}
		insert lstLog; 
	}
	// public static void gerarLog(String nomeObjeto, String acao, List<SObject> lst, Map<Id,Object> mapOld){
	// 	gerarLog(nomeObjeto, 'Quote__c', acao,lst,mapOld);

	// }
	private static List<History__c> gerarLogAlteracao(string objeto, string acao,Id idObj, Object objValorAtual, Object objValorAnterior){
		String jsonValorAtual = JSON.serialize(objValorAtual);
		String jsonValorAnterior = (acao != 'Insert'? JSON.serialize(objValorAnterior) : null);
		List<History__c> lstLog = new List<History__c>();
		string camposNaoAnalisar = '|WorkOrderName|SBQQ__LastSavedOn|QuantidadeHoras__c|DataInicioContratacaoEnergia__c|DataFinalContratacaoEnergia__c|TemFluxosRenegociacao__c|PrecoEscalonado__c|PrecoEnergiaPonderada__c|SubmercadoRenegociacao__c|FluxoAprovacao__c|SBQQ_Status__c|AprovacaoAlcadaAprovacaoSimples__c|AprovacaoTessouraria__c|AprovacaoAnaliseRisco__c|AprovacaoPrecificacao__c|AprovacaoAlcadaAprovacao__c|AprovacaoAnaliseCredito__c|PrecoMesaMenorTabela__c|Total__c|PrecoMesaMaiorTabela__c|QtdeHorasAno__c|MWMedio__c|PrecoEnergiaReal__c|PrecoEnergiaValidacao__c|QuoteRecordType__c|VolumeConsumidoLead__c|Cotacao__c|AnoMaisUm__c|PrecoEnergiaValidacao__c|VolumeTotalMeses__c|ValorMesaFaturar__c|PrecoEnergiaVPL__c|AlteradoPelaTrigger__c|VolumeMesVPL__c|VolumeVenda__c|AlteradoPelaTrigger__c|VolumeDisponivelLead__c|MargemNegociacao__c|ValorReferenciaEnergia__c|SBQQ__RegularAmount__c|SBQQ__NetAmount__c|SBQQ__CustomerAmount__c|SBQQ__ListAmount__c|SBQQ__AveragePartnerDiscount__c|Quote__c|CreatedById|CreatedDate|Account__c|ContaOportunidade__c|Id|LastModifiedById|QuoteRecordType|attributes|IsDeleted|ReajustePrecoDocProposta__c|IndiceDocProposta__c|AlertHeaderDatas|AlertFooterDatas|HoraValidadeDocProposta|DataValidadeDocProposta|LastModifiedDate|SystemModstamp|GarantiaDocPropostaFormatado__c|';
		Map<String, Object> mapJsonValorAtual = (Map<String, Object>) JSON.deserializeUntyped(jsonValorAtual);
		Map<String, Object> mapJsonValorAnterior = (acao != 'Insert' ? (Map<String, Object>) JSON.deserializeUntyped(jsonValorAnterior): null);
		String valorOld = null;
		String valorNew = null;
		for(String key : mapJsonValorAtual.keySet()){
			if(camposNaoAnalisar.indexOf('|' + key + '|') > -1) continue;
			if(acao == 'Insert' || mapJsonValorAnterior.get(key) != mapJsonValorAtual.get(key)) {
				lstLog.add(new History__c( 
					NAM__c = (Util.objDeveloperName(idObj) == 'NAM__c'? idObj: null),
					WorkOrder__c = (Util.objDeveloperName(idObj) == 'WorkOrder'? idObj: null), 
					Action__c = acao, Object__c = objeto, Field__c = key.replace('__c', ''), 
					OldValue__c = acao != 'Insert' ? String.valueOf(mapJsonValorAnterior.get(key)) : null, 
					NewValue__c = String.valueOf(mapJsonValorAtual.get(key)), 
					Revision__c = Integer.valueOf(mapJsonValorAtual.get('Revision__c') == null? 0 : mapJsonValorAtual.get('Revision__c'))
				 	)
				);
			}
        }
        return lstLog;
	}
}