#ifndef LiberaClient_H
#define LiberaClient_H

#include <mci/node.h>
#include <mci/mci.h>

namespace pyLibera {

	class pyLiberaClient {
	public:
		//LiberaClient();
		pyLiberaClient(std::string ip_address);
		pyLiberaClient(std::string ip_address, std::string &root_type);
		~pyLiberaClient();
		/* Get value from the specified Node */
		//template<class T>
		//T GetValue(std::string node);
		double GetValue(std::string node);
		void TreeWalk(const mci::Node &a_node, std::vector<std::string> &a_out);
		std::vector<std::string> MagicCommand(std::string a_path);
	private:
		mci::Node root;
		mci::Root node_type;
	};

    //extern template double LiberaClient::GetValue<double>(std::string node);
    //extern template std::string LiberaClient::GetValue<std::string>(std::string node);
}

#endif
