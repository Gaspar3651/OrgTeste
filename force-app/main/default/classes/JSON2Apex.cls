public class JSON2Apex {
	public static void DecodeToken(String token){
		// token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ0aFZhbmJ3c1ZaOENEODdYY2Fabng4TGZ4cTJZTjI4a0tWMVF1dGJJaFRRIn0.eyJqdGkiOiIyODIyYjYyOS05MDZkLTRjNmUtYTI2Mi0wOTcyMTNkNjMxODMiLCJleHAiOjE2NzIwNTg5MTgsIm5iZiI6MCwiaWF0IjoxNjcyMDU3MTE4LCJpc3MiOiJodHRwczovL2tleWNsb2FrLWhvbS5jc2ZjcHYud2NvcnAuY2FycmVmb3VyLmNvbS9hdXRoL3JlYWxtcy9DU0YtQ2FuYWlzLURpZ2l0YWlzIiwic3ViIjoiZjo5ZjBkZDVhNi1lOGQ2LTQ1YTUtOGY2OC1lMTE2MjZjODU3ZjA6OTY2NjM4MzcwNTIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJwd2FfY2FydGFvX2NhcnJlZm91ciIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjhlZDQzN2NhLTI4OWYtNDJjNy04YjI1LTQyMzAzODMwYjE3OCIsImFjciI6IjEiLCJzY29wZSI6ImNzZl9wbGF0YWZvcm1hX2RpZ2l0YWlzIHByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImFjY291bnRfbmFtZSI6IiIsImNwZiI6Ijk2NjYzODM3MDUyIiwidGlwb19jbGllbnRlIjoiMSIsImlkX2VtcHJlc2EiOiIxIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiOTY2NjM4MzcwNTIiLCJlbWFpbCI6Ijk2NjYzODM3MDUyIn0.kKDYpqvq73mptKlGqQQVSxP8FFTVoXqkUJs3spWKn2fbEfBvcdlawQfRZqZh9dBkTBixsoLi3U836QWcoQ2bV3v8mQKB2VXGhoCqzoJnxUC3oeafx8j5vKwlFc2GloL93t8BnCJ7Iv1dUNJz9eJTIrNGC1IozLiConKte689O-ZcJyGrFCoZlQZ6v81VTW7u9gkRUQwmnMp9bMQrxD8R8rGCQUccakuuHJmu0HeX_XcAn86sAQoD96p-tPrP9AcFdxpdk2v1dcZLGFm4qrKlRYWWWsd-zArsqgzlfQKI5j1VsAPoDuXgSgnaGeUwpySxaCBBDP8C_aZSgwq2OQnBVg';

		// TRANSFORMA TOKEN EM UMA LISTA DE STRING USANDO O ATRIBUTO '.' COMO PARAMETRO PARA DIVIDIR A STRING
		// A INFORMAÇÃO QUE QUEREMOS ESTÁ NA SEGUNDA POSIÇÃO DA LISTA, OU SEJA, listToken[1]
		List<String> listToken = token.split('\\.');

		// CONVERTE O TOKEN PARA O FORMATO JSON
		String info = EncodingUtil.base64Decode(listToken[1]).toString();

		// CONVERTE A INFORMAÇÃO JSON EM UM OBJETO COM AS INFORMAÇÕES
		JSON2Apex.TokenTO infoJson = JSON2Apex.TokenTO.Json2TokenTO(info);
		System.debug('-------------------> '+ infoJson.cpf);
	}

	public static TokenTO Json2TokenTO(String json) {
		return (TokenTO) System.JSON.deserialize(json, TokenTO.class);
	}	

	public class TokenTO{
		public String jti;
		public Integer exp;
		public Integer nbf;
		public Integer iat;
		public String iss;
		public String sub;
		public String typ;
		public String azp;
		public Integer auth_time;
		public String session_state;
		public String acr;
		public String scope;
		public Boolean email_verified;
		public String account_name;
		public String cpf;
		public String tipo_cliente;
		public String id_empresa;
		public String preferred_username;
		public String email;
	}
}