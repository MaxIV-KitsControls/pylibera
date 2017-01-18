/*
 * LiberaClient.cpp
 *
 *  Created on: Jan 10, 2017
 *      Author: vasmar
 */

#include "pyliberaclient.h"
// MCI includes
#include <mci/node.h>
#include "mci/mci.h"

namespace pyLibera {

	/* default constructor */
	pyLiberaClient::pyLiberaClient(std::string ip_address)
	{
	    //Start mci interface
		mci::Init();

	    if (ip_address.empty())
	    {
	      ip_address = "127.0.0.1";
	    }
		mci::Init();
		root = mci::Connect(ip_address);
	}

	/* constructor to select different node types */
	pyLiberaClient::pyLiberaClient(std::string ip_address, std::string root_type)
	{
	    //Start mci interface
		mci::Init();

		//Add ip
		if (ip_address.empty())
	    {
	      ip_address = "127.0.0.1";
	    }

		//Select type (application nodes or platform)
	    if (root_type=="platform")
	    {
	    	node_type = mci::Root::Platform;
	    }
	    else
	    	node_type = mci::Root::Application;

		root = mci::Connect(ip_address, node_type);
	}

//	template<class T>
//	T	pyLiberaClient::GetValue(std::string node)
//	{
//		mci::Node thisnode = root.GetNode(mci::Tokenize(node));
//		T node_value;
//		thisnode.GetValue(node_value);
//		return node_value;
//		//return const_cast<char*>(node_value.c_str());
//	}

	double pyLiberaClient::GetValue(std::string node) {
		mci::Node thisnode = root.GetNode(mci::Tokenize(node));
		double node_value;
		thisnode.GetValue(node_value);
		return node_value;
	}

	pyLiberaClient::~pyLiberaClient()
	{
		mci::Shutdown();
	}

	//template double pyLiberaClient::GetValue<double>(std::string node);
	//template std::string pyLiberaClient::GetValue<std::string>(std::string node);

}
