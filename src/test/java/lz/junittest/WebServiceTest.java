package lz.junittest;

import javax.xml.namespace.QName;

import lz.ws.IHelloService;

import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class WebServiceTest {

	private ApplicationContext ac;
	private IHelloService helloService;
	@Before
	public void before(){
		ac = new ClassPathXmlApplicationContext(new String[]{"spring.xml","spring-mybatis.xml","spring-cxf-client.xml"});
		helloService = (IHelloService)ac.getBean("client");
	}
	@Test
	public void test01(){
		String response = helloService.sayHello("happy");  
        System.out.println("Response: " + response);  
        System.exit(0);
	}
	@Test
	public void webServiceCXF() throws Exception{
    	//�������cxf �ͻ��˷���cxf�����webservice����  
        //ǧ���ס������cxf��webservice�������namespace ,����ͨ����  
        //����������һ�����⣬���ݹ�ȥ�Ĳ�������˽��ղ���  
        JaxWsDynamicClientFactory dcf = JaxWsDynamicClientFactory.newInstance();  
        org.apache.cxf.endpoint.Client client = dcf.createClient("http://localhost:8080/testmybatis/ws/helloService?wsdl");  
        //urlΪ����webService��wsdl��ַ  
        QName name=new QName("http://ws.lz/","sayBay");  
        //namespace�������ռ䣬methodName�Ƿ����� 
        String xmlStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"  
                 + "     <facelook>"  
                 + "        <condition>"  
                 + "            <name>��</name>"  
                 + "            <description></description>"  
                 + "            <pageno></pageno>"  
                 + "            <pagesize></pagesize>"  
                 + "        </condition>"  
                 + "     </facelook>";  
        //paramvalueΪ����ֵ  
        Object[] objects=client.invoke(name,xmlStr);   
        //����web Service//������ý��  
        System.out.println("test success");
        System.out.println(objects[0].toString());  
    }
}
