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
#include <istd/trace.h>

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
	pyLiberaClient::pyLiberaClient(std::string ip_address, std::string &root_type)
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

	/**
	 * Recursively collect values for all sub-nodes.
	 */
	void pyLiberaClient::TreeWalk(const mci::Node &a_node, std::vector<std::string> &a_out)
	{
	    std::string s = istd::ToString(a_node.GetRelPath());

	    if (a_node.GetValueType() != mci::eNvUndefined && a_node.IsReadable()) {
	        s = s + "=" + a_node.ToString(0);
	    }
	    a_out.push_back(s);

	    for (size_t i(0); i < a_node.GetNodeCount(); ++i) {
	        a_out.resize(a_out.size());
	        TreeWalk(a_node.GetNode(i), a_out);
	    }
	}

	/**
	 * Fill the output argument with value of the ireg node and its sub-nodes.
	 */
	 std::vector<std::string> pyLiberaClient::MagicCommand(std::string a_path)
	 //bool MagicCommand(mci::Node m_root, const std::string &a_path, Tango::DevVarStringArray a_out)
	 {
	     istd_FTRC();

	     std::vector<std::string> a_out;

	     try {
	         if (a_path == "dump") {
	             TreeWalk(root, a_out);
	         }
	         else {
	              TreeWalk(root.GetNode(mci::Tokenize(std::string(a_path))), a_out);
	         }
	     }
	     catch (istd::Exception &e)
	     {
	         istd_TRC(istd::eTrcLow, "Exception thrown on read node!");
	         istd_TRC(istd::eTrcLow, e.what());

	     }
	     return a_out;
	 }

	pyLiberaClient::~pyLiberaClient()
	{
		mci::Shutdown();
	}
	//template double pyLiberaClient::GetValue<double>(std::string node);
	//template std::string pyLiberaClient::GetValue<std::string>(std::string node);

}
