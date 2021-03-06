/************************************************
Copyright (c) 2016, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.// Copyright (c) 2015 Xilinx, Inc.
************************************************/

#include "echo_server_application.hpp"

using namespace hls;


void client(	stream<ap_uint<16> >& sessioIdFifo,
				stream<ap_uint<16> >& lengthFifo,
				stream<axiWord>& dataFifo,
				stream<appTxMeta>& txMetaData, stream<axiWord>& txData)
{
#pragma HLS PIPELINE II=1

	// Reads new data from memory and writes it into fifo
	// Read & write metadata only once per package
	static ap_uint<1> esac_fsmState = 0;
	//static ap_uint<16> ksvc_length;

	ap_uint<16> sessionID;
	ap_uint<16> length;
	axiWord currWord;

	switch (esac_fsmState)
	{
	case 0:
		if (!sessioIdFifo.empty() && !lengthFifo.empty() && !txMetaData.full())
		{
			sessioIdFifo.read(sessionID);
			lengthFifo.read(length);
			txMetaData.write(appTxMeta(sessionID, length));
			esac_fsmState = 1;
		}
		break;
	case 1:
		if (!dataFifo.empty() && !txData.full())
		{
			dataFifo.read(currWord);
			txData.write(currWord);
			if (currWord.last)
			{
				esac_fsmState = 0;
			}
		}
		break;
	}

}

void dummy(	stream<ipTuple>& openConnection, stream<openStatus>& openConStatus,
			stream<ap_uint<16> >& closeConnection,
			stream<ap_int<17> >& txStatus)
{
	#pragma HLS PIPELINE II=1

	openStatus newConn;
	ipTuple tuple;

	// Dummy code should never be executed, this is necessary because every streams has to be written/read
	if (!openConStatus.empty() && !openConnection.full() && !closeConnection.full())
	{
		openConStatus.read(newConn);
		tuple.ip_address = 0x0a010101;
		tuple.ip_port = 0x3412;
		openConnection.write(tuple);
		if (newConn.success)
		{
			closeConnection.write(newConn.sessionID);
			//closePort.write(tuple.ip_port);
		}
	}

	if (!txStatus.empty()) //Make Checks
	{
		txStatus.read();
	}
}


void open_port(	stream<ap_uint<16> >& listenPort, stream<bool>& listenPortStatus,
				stream<appNotification>& notifications, stream<appReadRequest>& readRequest,
				stream<ap_uint<16> >& lenghtFifo)
{
#pragma HLS PIPELINE II=1

	static bool listenDone = false;
	static bool waitPortStatus = false;

	appNotification notification;

	// Open/Listen on Port at startup
	if (!listenDone && !waitPortStatus && !listenPort.full())
	{
#ifndef __SYNTHESIS__
		listenPort.write(11213);
#else
		//listenPort.write(11213);
		listenPort.write(7);
#endif
		waitPortStatus = true;
	}
	// Check if listening on Port was successful, otherwise try again
	else if (waitPortStatus && !listenPortStatus.empty())
	{
		listenPortStatus.read(listenDone);
		waitPortStatus = false;
	}

	// Receive notifications, about new data which is available
	if (!notifications.empty() && !readRequest.full() && !lenghtFifo.full())
	{
		notifications.read(notification);
		std::cout << notification.ipAddress << "\t" << notification.dstPort << std::endl;
		if (notification.length != 0)
		{
			readRequest.write(appReadRequest(notification.sessionID, notification.length));
			lenghtFifo.write(notification.length);
		}
	}
}

void server(	stream<ap_uint<16> >& rxMetaData, stream<axiWord>& rxData,
				stream<ap_uint<16> >& sessioIdFifo, stream<axiWord>& dataFifo)
{
#pragma HLS PIPELINE II=1


	// Reads new data from memory and writes it into fifo
	// Read & write metadata only once per package
	static ap_uint<1> ksvs_fsmState = 0;

	ap_uint<16> sessionID;
	axiWord currWord;

	switch (ksvs_fsmState)
	{
	case 0:
		if (!rxMetaData.empty() && !sessioIdFifo.full())
		{
			rxMetaData.read(sessionID);
			sessioIdFifo.write(sessionID);
			ksvs_fsmState = 1;
		}
		break;
	case 1:
		if (!rxData.empty() && !dataFifo.full())
		{
			rxData.read(currWord);
			dataFifo.write(currWord);
			if (currWord.last)
			{
				ksvs_fsmState = 0;
			}
		}
		break;
	}
}

/** @ingroup kvs_server
 *
 */
void echo_server_application(	stream<ap_uint<16> >& listenPort, stream<bool>& listenPortStatus,
								stream<appNotification>& notifications, stream<appReadRequest>& readRequest,
								stream<ap_uint<16> >& rxMetaData, stream<axiWord>& rxData,
								stream<ipTuple>& openConnection, stream<openStatus>& openConStatus,
								stream<ap_uint<16> >& closeConnection,
								stream<appTxMeta>& txMetaData,
								stream<axiWord> & txData,
								stream<ap_int<17> >& txStatus)
{
	#pragma HLS DATAFLOW
	#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS resource core=AXI4Stream variable=listenPort metadata="-bus_bundle m_axis_listen_port"
#pragma HLS resource core=AXI4Stream variable=listenPortStatus metadata="-bus_bundle s_axis_listen_port_status"
//#pragma HLS INTERFACE axis port=listenPortStatus metadata="-bus_bundle s_axis_listen_port_status"
	//#pragma HLS resource core=AXI4Stream variable=closePort metadata="-bus_bundle m_axis_close_port"

#pragma HLS resource core=AXI4Stream variable=notifications metadata="-bus_bundle s_axis_notifications"
#pragma HLS resource core=AXI4Stream variable=readRequest metadata="-bus_bundle m_axis_read_package"
#pragma HLS DATA_PACK variable=notifications
#pragma HLS DATA_PACK variable=readRequest

#pragma HLS resource core=AXI4Stream variable=rxMetaData metadata="-bus_bundle s_axis_rx_metadata"
#pragma HLS resource core=AXI4Stream variable=rxData metadata="-bus_bundle s_axis_rx_data"
#pragma HLS DATA_PACK variable=rxData

#pragma HLS resource core=AXI4Stream variable=openConnection metadata="-bus_bundle m_axis_open_connection"
#pragma HLS resource core=AXI4Stream variable=openConStatus metadata="-bus_bundle s_axis_open_status"
#pragma HLS DATA_PACK variable=openConnection
#pragma HLS DATA_PACK variable=openConStatus

#pragma HLS resource core=AXI4Stream variable=closeConnection metadata="-bus_bundle m_axis_close_connection"

#pragma HLS resource core=AXI4Stream variable=txMetaData metadata="-bus_bundle m_axis_tx_metadata"
#pragma HLS resource core=AXI4Stream variable=txData metadata="-bus_bundle m_axis_tx_data"
//#pragma HLS INTERFACE axis port=txData
#pragma HLS resource core=AXI4Stream variable=txStatus metadata="-bus_bundle s_axis_tx_status"
#pragma HLS DATA_PACK variable=txMetaData
	#pragma HLS DATA_PACK variable=txData

	static stream<ap_uint<16> >		esa_sessionidFifo("esa_sessionidFifo");
	static stream<ap_uint<16> >		esa_lengthFifo("esa_lengthFifo");
	static stream<axiWord>			esa_dataFifo("esa_dataFifo");

#pragma HLS stream variable=esa_sessionidFifo depth=64
#pragma HLS stream variable=esa_lengthFifo depth=64
#pragma HLS stream variable=esa_dataFifo depth=2048
//#pragma HLS DATA_PACK variable=kvs_dataFifo

	client(esa_sessionidFifo, esa_lengthFifo, esa_dataFifo, txMetaData, txData);
	server(rxMetaData, rxData, esa_sessionidFifo, esa_dataFifo);
	open_port(listenPort, listenPortStatus, notifications, readRequest, esa_lengthFifo);
	dummy(openConnection, openConStatus, closeConnection, txStatus);


}
