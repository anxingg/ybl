package cn.sunline.framework.controller.vo.v4.supplier.enums;

public enum E_V4_ASSETS_TYPE {
	
	ACCOUNTS_RECEIVABLE("应收账款",1),
	ACCOUNTS_PAYABLE("应付账款",2),
	BILL("票据",3);
	
	String name;
	int status;
	
	E_V4_ASSETS_TYPE(String name,int status){
		this.name = name;
		this.status = status;
	}
	
	public static String getName(int optype) {
		for (E_V4_ASSETS_TYPE op : values()) {
			if (op.getStatus() == optype) {
				return op.name;
			}
		}
		return "";
	}
	
	public static E_V4_ASSETS_TYPE get(int optype) {
		for (E_V4_ASSETS_TYPE op : values()) {
			if (op.getStatus() == optype) {
				return op;
			}
		}
		return null;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
}
  